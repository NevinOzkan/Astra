//
//  NumerologyViewController.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class NumerologyViewController: UIViewController {
    
    private let viewModel: NumerologyViewModel
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    private var cardViews: [UIView] = []
    private var buttonGradients: [UIButton: CAGradientLayer] = [:]
    
    init(viewModel: NumerologyViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil ?? "NumerologyViewController", bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupUI()
        setupViewModel()
        setupCards()
        setupNotifications()
    }
    
    private func setupNotifications() {
        // Premium durumu değiştiğinde kartları yenile
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(premiumStatusChanged),
            name: NSNotification.Name("PremiumStatusChanged"),
            object: nil
        )
    }
    
    @objc private func premiumStatusChanged() {
        // Premium durumu değiştiğinde kartları yenile
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.load()
            self?.setupCards()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1).cgColor,
            UIColor(red: 0.1, green: 0.05, blue: 0.2, alpha: 1).cgColor,
            UIColor(red: 0.05, green: 0.1, blue: 0.25, alpha: 1).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        navigationItem.title = "Numeroloji"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        // Scroll view horizontal
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // Stack view horizontal
        contentStackView.axis = .horizontal
        contentStackView.spacing = 20
        contentStackView.alignment = .center
        contentStackView.distribution = .fill
    }
    
    private func setupCards() {
        // Mevcut kartları temizle
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews.removeAll()
        buttonGradients.removeAll()
        
        let cards = viewModel.availableCards
        
        // Debug: Premium durumunu kontrol et
        print("🔍 Premium durumu: \(viewModel.isPremiumUser)")
        for card in cards {
            print("📋 Kart: \(card.title) - isPremium: \(card.isPremium) - isLocked: \(card.isLocked)")
            let cardView = createCardView(for: card)
            contentStackView.addArrangedSubview(cardView)
            cardViews.append(cardView)
        }

    }
    
    private func createCardView(for card: NumerologyCard) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 32
        containerView.clipsToBounds = false
        containerView.backgroundColor = .clear
        
        // Premium shadow ve glow
        containerView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.4).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 12)
        containerView.layer.shadowRadius = 24
        containerView.layer.shadowOpacity = 1.0
        
        // Gradient arka plan
        let gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.layer.cornerRadius = 32
        gradientView.clipsToBounds = true
        containerView.addSubview(gradientView)
        
        // Kart tipine göre gradient renkleri
        let gradientColors: [CGColor]
        if card.id == "lifePath" {
            gradientColors = [
                UIColor(red: 0.3, green: 0.2, blue: 0.6, alpha: 0.8).cgColor,
                UIColor(red: 0.4, green: 0.3, blue: 0.7, alpha: 0.6).cgColor
            ]
        } else if card.id == "daily" {
            gradientColors = [
                UIColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 0.8).cgColor,
                UIColor(red: 0.3, green: 0.5, blue: 0.7, alpha: 0.6).cgColor
            ]
        } else if card.id == "evolution" {
            gradientColors = [
                UIColor(red: 0.5, green: 0.2, blue: 0.5, alpha: 0.8).cgColor,
                UIColor(red: 0.6, green: 0.3, blue: 0.6, alpha: 0.6).cgColor
            ]
        } else {
            gradientColors = [
                UIColor(red: 0.4, green: 0.2, blue: 0.5, alpha: 0.8).cgColor,
                UIColor(red: 0.5, green: 0.3, blue: 0.6, alpha: 0.6).cgColor
            ]
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 32
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Blur overlay
        let blurView = UIView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        blurView.layer.cornerRadius = 32
        blurView.clipsToBounds = true
        gradientView.addSubview(blurView)
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 32
        blurEffectView.clipsToBounds = true
        blurView.insertSubview(blurEffectView, at: 0)
        
        // Premium kartlar için ekstra blur overlay (sadece premium olmayan kullanıcılar için)
        var premiumBlurOverlay: UIView?
        // Premium kartlar ve kilitli olanlar için blur overlay ekle
        if card.isPremium && card.isLocked {
            print("🔒 Premium kart kilitli: \(card.title) - Blur overlay ekleniyor")
            let overlay = UIView()
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            overlay.layer.cornerRadius = 28
            overlay.clipsToBounds = true
            overlay.translatesAutoresizingMaskIntoConstraints = false
            blurView.addSubview(overlay)
            
            let overlayBlurEffect = UIBlurEffect(style: .systemMaterialDark)
            let overlayBlurView = UIVisualEffectView(effect: overlayBlurEffect)
            overlayBlurView.frame = overlay.bounds
            overlayBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlayBlurView.layer.cornerRadius = 28
            overlayBlurView.clipsToBounds = true
            overlay.insertSubview(overlayBlurView, at: 0)
            
            premiumBlurOverlay = overlay
        } else if card.isPremium {
            print("⚠️ Premium kart ama kilitli değil: \(card.title) - isLocked: \(card.isLocked)")
        }
        
        // Content stack
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        blurView.addSubview(contentStack)
        
        // Icon container (üstte küçük ikon)
        let iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iconContainer.heightAnchor.constraint(equalToConstant: 48).isActive = true
        iconContainer.layer.cornerRadius = 24
        iconContainer.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        contentStack.addArrangedSubview(iconContainer)
        
        let iconLabel = UILabel()
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.font = .systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        
        // Kart tipine göre ikon
        if card.id == "lifePath" {
            iconLabel.text = "🌟"
        } else if card.id == "daily" {
            iconLabel.text = "📅"
        } else if card.id == "destiny" {
            iconLabel.text = "✨"
        } else if card.id == "soulUrge" {
            iconLabel.text = "❤️"
        } else if card.id == "personality" {
            iconLabel.text = "🎭"
        } else if card.id == "evolution" {
            iconLabel.text = "🔮"
        } else {
            iconLabel.text = "⭐"
        }
        
        iconContainer.addSubview(iconLabel)
        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
        ])
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = card.title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        contentStack.addArrangedSubview(titleLabel)
        
        // Number/Content area
        if card.isPremium && card.isLocked {
            // Premium kartlar için kilit ikonu ve teaser metin
            let lockIcon = UILabel()
            lockIcon.text = "🔒"
            lockIcon.font = .systemFont(ofSize: 56)
            lockIcon.textAlignment = .center
            contentStack.addArrangedSubview(lockIcon)
            
            // Teaser metin
            let teaserLabel = UILabel()
            teaserLabel.text = viewModel.getTeaserText(for: card.id)
            teaserLabel.textColor = UIColor.white.withAlphaComponent(0.7)
            teaserLabel.font = .systemFont(ofSize: 14, weight: .medium)
            teaserLabel.textAlignment = .center
            teaserLabel.numberOfLines = 2
            teaserLabel.lineBreakMode = .byWordWrapping
            contentStack.addArrangedSubview(teaserLabel)
        } else if card.id == "evolution" {
            // Tekâmül Sayısı için özel görünüm
            if let evolutionNumbers = card.evolutionNumbers, !evolutionNumbers.isEmpty {
                let numbersStack = UIStackView()
                numbersStack.axis = .horizontal
                numbersStack.distribution = .fillEqually
                numbersStack.spacing = 8
                numbersStack.translatesAutoresizingMaskIntoConstraints = false
                
                for number in evolutionNumbers.prefix(6) { // Maksimum 6 sayı göster
                    let numberView = UIView()
                    numberView.translatesAutoresizingMaskIntoConstraints = false
                    numberView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    numberView.heightAnchor.constraint(equalToConstant: 40).isActive = true
                    numberView.layer.cornerRadius = 20
                    numberView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                    
                    let numLabel = UILabel()
                    numLabel.text = "\(number)"
                    numLabel.textColor = .white
                    numLabel.font = .systemFont(ofSize: 20, weight: .bold)
                    numLabel.textAlignment = .center
                    numLabel.translatesAutoresizingMaskIntoConstraints = false
                    numberView.addSubview(numLabel)
                    
                    NSLayoutConstraint.activate([
                        numLabel.centerXAnchor.constraint(equalTo: numberView.centerXAnchor),
                        numLabel.centerYAnchor.constraint(equalTo: numberView.centerYAnchor)
                    ])
                    
                    numbersStack.addArrangedSubview(numberView)
                }
                
                contentStack.addArrangedSubview(numbersStack)
            } else if card.evolutionNumbers?.isEmpty == true {
                let checkmarkLabel = UILabel()
                checkmarkLabel.text = "✓"
                checkmarkLabel.textColor = .systemGreen
                checkmarkLabel.font = .systemFont(ofSize: 64, weight: .bold)
                checkmarkLabel.textAlignment = .center
                contentStack.addArrangedSubview(checkmarkLabel)
            }
        } else if let number = card.number {
            // Normal sayı gösterimi
            let numberLabel = UILabel()
            numberLabel.text = "\(number)"
            numberLabel.textColor = .white
            numberLabel.font = .systemFont(ofSize: 72, weight: .bold)
            numberLabel.textAlignment = .center
            
            // Glow efekti
            numberLabel.layer.shadowColor = UIColor.white.cgColor
            numberLabel.layer.shadowOffset = .zero
            numberLabel.layer.shadowRadius = 10
            numberLabel.layer.shadowOpacity = 0.5
            
            contentStack.addArrangedSubview(numberLabel)
        }
        
        // Description label (premium locked kartlarda gösterilmez)
        if !(card.isPremium && card.isLocked) {
            let descLabel = UILabel()
            descLabel.text = card.description
            descLabel.textColor = UIColor.white.withAlphaComponent(0.85)
            descLabel.font = .systemFont(ofSize: 13, weight: .medium)
            descLabel.textAlignment = .center
            descLabel.numberOfLines = 0
            descLabel.lineBreakMode = .byWordWrapping
            contentStack.addArrangedSubview(descLabel)
        }
        
        // Premium button (if locked)
        var premiumButton: UIButton?
        if card.isPremium && card.isLocked {
            let button = UIButton(type: .system)
            button.setTitle("✨ Premium ile aç", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
            
            // Gradient background
            let buttonGradient = CAGradientLayer()
            buttonGradient.colors = [
                UIColor.systemYellow.withAlphaComponent(0.4).cgColor,
                UIColor.systemOrange.withAlphaComponent(0.3).cgColor
            ]
            buttonGradient.startPoint = CGPoint(x: 0, y: 0)
            buttonGradient.endPoint = CGPoint(x: 1, y: 1)
            buttonGradient.cornerRadius = 14
            button.layer.insertSublayer(buttonGradient, at: 0)
            
            button.layer.cornerRadius = 14
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.systemYellow.withAlphaComponent(0.6).cgColor
            
            // Shadow
            button.layer.shadowColor = UIColor.systemYellow.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowRadius = 8
            button.layer.shadowOpacity = 0.4
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(premiumButtonTapped(_:)), for: .touchUpInside)
            blurView.addSubview(button)
            premiumButton = button
            
            // Gradient'ı sakla
            buttonGradients[button] = buttonGradient
        }
        
        // Constraints
        var constraints: [NSLayoutConstraint] = [
            containerView.widthAnchor.constraint(equalToConstant: 320),
            containerView.heightAnchor.constraint(equalToConstant: 380),
            
            gradientView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: containerView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            blurView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: gradientView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor),
            
            contentStack.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -20),
            contentStack.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 28)
        ]
        
        // Gradient layer frame update
        DispatchQueue.main.async {
            gradientLayer.frame = gradientView.bounds
        }
        
        // Premium blur overlay constraints
        if let overlay = premiumBlurOverlay {
            constraints.append(contentsOf: [
                overlay.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
                overlay.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
                overlay.topAnchor.constraint(equalTo: blurView.topAnchor),
                overlay.bottomAnchor.constraint(equalTo: blurView.bottomAnchor)
            ])
        }
        
        // Premium button constraints
        if let button = premiumButton {
            constraints.append(contentsOf: [
                button.heightAnchor.constraint(equalToConstant: 44),
                button.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 20),
                button.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -20),
                button.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 20),
                button.bottomAnchor.constraint(lessThanOrEqualTo: blurView.bottomAnchor, constant: -24)
            ])
        } else {
            constraints.append(
                contentStack.bottomAnchor.constraint(lessThanOrEqualTo: blurView.bottomAnchor, constant: -28)
            )
        }
        
        NSLayoutConstraint.activate(constraints)
        
        // Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        containerView.addGestureRecognizer(tapGesture)
        containerView.accessibilityIdentifier = card.id
        
        return containerView
    }
    
    @objc private func premiumButtonTapped(_ sender: UIButton) {
        // Premium paywall aç
        let paywallVC = PremiumPaywallViewController()
        paywallVC.modalPresentationStyle = .fullScreen
        paywallVC.onPurchaseComplete = { [weak self] in
            self?.viewModel.load()
            self?.setupCards()
        }
        present(paywallVC, animated: true)
    }
    
    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let cardView = gesture.view,
              let cardId = cardView.accessibilityIdentifier,
              let card = viewModel.availableCards.first(where: { $0.id == cardId }) else { return }
        
        // Premium kartlar için paywall aç
        if card.isPremium && card.isLocked {
            let paywallVC = PremiumPaywallViewController()
            paywallVC.modalPresentationStyle = .fullScreen
            paywallVC.onPurchaseComplete = { [weak self] in
                self?.viewModel.load()
                self?.setupCards()
            }
            present(paywallVC, animated: true)
            return
        }
        
        // Erişilebilir kartlar için detay ekranını aç
        if viewModel.canAccessCard(withId: card.id) {
            let detailVC = NumerologyDetailViewController(card: card, viewModel: viewModel)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    private func setupViewModel() {
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.setupCards()
            }
        }
        
        viewModel.onNameRequired = { [weak self] in
            DispatchQueue.main.async {
                self?.showNameInputAlert()
            }
        }
        
        viewModel.onBirthDateRequired = { [weak self] in
            DispatchQueue.main.async {
                self?.showBirthDatePicker()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                print("Hata: \(errorMessage)")
            }
        }
        
        viewModel.load()
    }
    
    private func showNameInputAlert() {
        let alert = UIAlertController(title: "İsminizi Girin", message: "Numeroloji hesaplamaları için isminize ihtiyacımız var.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Ad Soyad"
            textField.autocapitalizationType = .words
        }
        
        alert.addAction(UIAlertAction(title: "Kaydet", style: .default) { [weak self] _ in
            if let textField = alert.textFields?.first, let name = textField.text, !name.isEmpty {
                self?.viewModel.saveUserName(name)
                // İsim kaydedildikten sonra doğum tarihi kontrolü yap
                if !(self?.viewModel.hasBirthDate ?? false) {
                    self?.viewModel.onBirthDateRequired?()
                } else {
                    self?.viewModel.load()
                }
            }
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showBirthDatePicker() {
        let alert = UIAlertController(title: "Doğum Tarihinizi Seçin", message: "Numeroloji hesaplamaları için doğum tarihinize ihtiyacımız var.", preferredStyle: .actionSheet)
        
        // Date picker ekle
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date() // Bugünden sonraki tarihler seçilemez
        datePicker.date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date() // Varsayılan: 25 yaş
        
        // iOS 14+ için date picker'ı alert'e ekle
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        alert.view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 60),
            datePicker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -20),
            datePicker.heightAnchor.constraint(equalToConstant: 200),
            alert.view.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        alert.addAction(UIAlertAction(title: "Kaydet", style: .default) { [weak self] _ in
            self?.viewModel.saveBirthDate(datePicker.date)
            self?.viewModel.load()
        })
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Background gradient
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
        
        // Card gradients - her kartın gradient'ını güncelle
        for cardView in cardViews {
            // Gradient view'ı bul (containerView'ın ilk subview'ı)
            if let gradientView = cardView.subviews.first {
                // Gradient layer'ı bul ve güncelle
                if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
                    gradientLayer.frame = gradientView.bounds
                }
            }
        }
        
        // Button gradients güncelle
        for (button, gradientLayer) in buttonGradients {
            gradientLayer.frame = button.bounds
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
    }
}


