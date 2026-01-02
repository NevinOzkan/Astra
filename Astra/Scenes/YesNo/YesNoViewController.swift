//
//  YesNoViewController.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class YesNoViewController: UIViewController {
    
    private let viewModel: YesNoViewModel
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var guideTitleLabel: UILabel!
    @IBOutlet weak var guideSubtitleLabel: UILabel!
    @IBOutlet weak var cardsStackView: UIStackView!
    
    // Card Views
    private var cardViews: [UIView] = []
    
    // Card data storage
    private struct CardData {
        let card: YesNoCard
        let container: UIView
        let front: UIView
        let back: UIView
        let backLabel: UILabel
    }
    
    private var cardDataMap: [UIView: CardData] = [:]
    
    init(viewModel: YesNoViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil ?? "YesNoViewController", bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupUI()
        setupCards()
        setupViewModel()
    }
    
    private func setupBackground() {
        // Ortak gradient arka plan (Home ve Settings ile aynı)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1).cgColor, // Deep navy
            UIColor(red: 0.1, green: 0.05, blue: 0.2, alpha: 1).cgColor,  // Mor ton
            UIColor(red: 0.05, green: 0.1, blue: 0.25, alpha: 1).cgColor  // Lacivert
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        // Başlık
        titleLabel?.text = "Evet mi Hayır mı?"
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel?.textAlignment = .center
        
        // Alt başlık
        subtitleLabel?.text = "Cevap kartlarda yazıyor."
        subtitleLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
        subtitleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel?.textAlignment = .center
        
        // Rehber başlık
        guideTitleLabel?.text = "Yıldız Seç"
        guideTitleLabel?.textColor = .white
        guideTitleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        guideTitleLabel?.textAlignment = .center
        
        // Rehber alt başlık
        guideSubtitleLabel?.text = "Gözlerini kapat, niyetini düşün ve bir kart seç."
        guideSubtitleLabel?.textColor = UIColor.white.withAlphaComponent(0.6)
        guideSubtitleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        guideSubtitleLabel?.textAlignment = .center
        guideSubtitleLabel?.numberOfLines = 0
    }
    
    private func setupCards() {
        guard let stackView = cardsStackView else { return }
        
        // Mevcut card view'ları temizle
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews.removeAll()
        
        // Kartları oluştur
        let cards = viewModel.availableCards
        for card in cards {
            let cardView = createCardView(for: card)
            stackView.addArrangedSubview(cardView)
            cardViews.append(cardView)
        }
        
        // Stack view ayarları
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.alignment = .center
    }
    
    private func createCardView(for card: YesNoCard) -> UIView {
        // Ana container
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Kart container (flip için)
        let cardContainerView = UIView()
        cardContainerView.backgroundColor = .clear
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cardContainerView)
        
        // Ön yüz (Front View)
        let frontView = UIView()
        frontView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        frontView.layer.cornerRadius = 16
        frontView.layer.borderWidth = 1.5
        frontView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        frontView.layer.shadowColor = UIColor.black.cgColor
        frontView.layer.shadowOffset = CGSize(width: 0, height: 4)
        frontView.layer.shadowRadius = 8
        frontView.layer.shadowOpacity = 0.3
        frontView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.addSubview(frontView)
        
        // Ön yüz label
        let frontLabel = UILabel()
        frontLabel.text = card.title
        frontLabel.textColor = .white
        frontLabel.font = .systemFont(ofSize: 24, weight: .bold)
        frontLabel.textAlignment = .center
        frontLabel.translatesAutoresizingMaskIntoConstraints = false
        frontView.addSubview(frontLabel)
        
        // Arka yüz (Back View) - başlangıçta gizli
        let backView = UIView()
        backView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        backView.layer.cornerRadius = 16
        backView.layer.borderWidth = 1.5
        backView.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 0, height: 4)
        backView.layer.shadowRadius = 8
        backView.layer.shadowOpacity = 0.3
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.isHidden = true
        cardContainerView.addSubview(backView)
        
        // Arka yüz label (mesaj) - başlangıçta boş, seçildiğinde doldurulacak
        let backLabel = UILabel()
        backLabel.text = "" // Başlangıçta boş, seçildiğinde mesaj gösterilecek
        backLabel.textColor = .white
        backLabel.font = .systemFont(ofSize: 12, weight: .regular)
        backLabel.textAlignment = .center
        backLabel.numberOfLines = 0
        backLabel.lineBreakMode = .byWordWrapping
        backLabel.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(backLabel)
        
        // Hafif eğik duruş için transform
        let rotationAngle: CGFloat = card == .yes ? -0.05 : 0.05
        cardContainerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Container - uzun mesajlar için daha geniş ve yüksek
            containerView.widthAnchor.constraint(equalToConstant: 140),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            
            // Card container
            cardContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            cardContainerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            cardContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Front view
            frontView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            frontView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            frontView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            frontView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            
            // Front label
            frontLabel.centerXAnchor.constraint(equalTo: frontView.centerXAnchor),
            frontLabel.centerYAnchor.constraint(equalTo: frontView.centerYAnchor),
            
            // Back view
            backView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            backView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            backView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            
            // Back label - padding ve top/bottom constraints
            backLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            backLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            backLabel.topAnchor.constraint(greaterThanOrEqualTo: backView.topAnchor, constant: 12),
            backLabel.bottomAnchor.constraint(lessThanOrEqualTo: backView.bottomAnchor, constant: -12),
            backLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor)
        ])
        
        // Card data'yı sakla
        let cardData = CardData(card: card, container: cardContainerView, front: frontView, back: backView, backLabel: backLabel)
        cardDataMap[containerView] = cardData
        
        // Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.tag = card.rawValue.hashValue
        
        return containerView
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view else { return }
        
        // Tag'den card'ı bul
        let card: YesNoCard?
        switch tappedView.tag {
        case YesNoCard.yes.rawValue.hashValue:
            card = .yes
        case YesNoCard.no.rawValue.hashValue:
            card = .no
        default:
            card = nil
        }
        
        guard let selectedCard = card else { return }
        
        // Animasyon ve seçim
        animateCardSelection(selectedCard: tappedView, card: selectedCard)
    }
    
    private func animateCardSelection(selectedCard: UIView, card: YesNoCard) {
        // Card data'yı al
        guard let cardData = cardDataMap[selectedCard] else {
            return
        }
        
        let cardContainer = cardData.container
        let frontView = cardData.front
        let backView = cardData.back
        let backLabel = cardData.backLabel
        
        // Diğer kartları yarı saydam yap
        UIView.animate(withDuration: 0.3) {
            for cardView in self.cardViews {
                if cardView != selectedCard {
                    cardView.alpha = 0.3
                }
            }
        }
        
        // Seçilen kartı büyüt
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            selectedCard.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        } completion: { _ in
            // Flip animasyonu
            self.flipCard(container: cardContainer, frontView: frontView, backView: backView, card: card, backLabel: backLabel)
        }
        
        // ViewModel'e bildir
        viewModel.selectCard(card)
    }
    
    private func flipCard(container: UIView, frontView: UIView, backView: UIView, card: YesNoCard, backLabel: UILabel) {
        // Mesajı ViewModel'den al ve göster
        let message = viewModel.getMessage(for: card)
        backLabel.text = message
        
        // Arka yüzü göster
        backView.isHidden = false
        
        // 3D flip animasyonu
        UIView.transition(with: container, duration: 0.6, options: [.transitionFlipFromRight, .curveEaseInOut], animations: {
            frontView.isHidden = true
            backView.isHidden = false
        }, completion: nil)
    }
    
    private func setupViewModel() {
        viewModel.onCardSelected = { [weak self] card, message in
            print("Kart seçildi: \(card.title) - Mesaj: \(message)")
        }
        
        viewModel.onError = { [weak self] errorMessage in
            print("Hata: \(errorMessage)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Gradient layer'ı güncelle
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation bar'ı gizle
        navigationItem.title = ""
        navigationController?.navigationBar.isHidden = true
        
        // Seçimi sıfırla
        viewModel.resetSelection()
        resetCardAnimations()
    }
    
    private func resetCardAnimations() {
        UIView.animate(withDuration: 0.3) {
            for cardView in self.cardViews {
                cardView.transform = .identity
                cardView.alpha = 1.0
                
                // Kartları ön yüze çevir
                if let cardData = self.cardDataMap[cardView] {
                    cardData.front.isHidden = false
                    cardData.back.isHidden = true
                }
            }
        }
    }
}

