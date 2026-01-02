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
        containerView.layer.cornerRadius = 28
        containerView.clipsToBounds = false
        containerView.backgroundColor = .clear
        
        // Shadow
        containerView.layer.shadowColor = UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 0.3).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        containerView.layer.shadowRadius = 20
        containerView.layer.shadowOpacity = 1.0
        
        // Blur view
        let blurView = UIView()
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        blurView.layer.cornerRadius = 28
        blurView.clipsToBounds = true
        containerView.addSubview(blurView)
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 28
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
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        blurView.addSubview(contentStack)
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = card.title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentStack.addArrangedSubview(titleLabel)
        
        // Number label (büyük) - Günün Sayısı her zaman gösterilmeli
        if let number = card.number {
            let numberLabel = UILabel()
            numberLabel.text = "\(number)"
            numberLabel.textColor = .white
            numberLabel.font = .systemFont(ofSize: 64, weight: .bold)
            numberLabel.textAlignment = .center
            contentStack.addArrangedSubview(numberLabel)
        } else if card.isPremium && card.isLocked {
            // Premium kartlar için kilit ikonu (sadece sayı yoksa)
            let lockIcon = UILabel()
            lockIcon.text = "🔒"
            lockIcon.font = .systemFont(ofSize: 48)
            lockIcon.textAlignment = .center
            contentStack.addArrangedSubview(lockIcon)
        }
        
        // Description label
        let descLabel = UILabel()
        descLabel.text = card.description
        descLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        contentStack.addArrangedSubview(descLabel)
        
        // Premium button (if locked)
        var premiumButton: UIButton?
        if card.isPremium && card.isLocked {
            let button = UIButton(type: .system)
            button.setTitle("Premium ile aç", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            button.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.3)
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.systemYellow.cgColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(premiumButtonTapped(_:)), for: .touchUpInside)
            blurView.addSubview(button)
            premiumButton = button
        }
        
        // Constraints
        var constraints: [NSLayoutConstraint] = [
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 320),
            
            blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            contentStack.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -24),
            contentStack.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 32)
        ]
        
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
                button.heightAnchor.constraint(equalToConstant: 40),
                button.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 24),
                button.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -24),
                button.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 16),
                button.bottomAnchor.constraint(lessThanOrEqualTo: blurView.bottomAnchor, constant: -24)
            ])
        } else {
            constraints.append(
                contentStack.bottomAnchor.constraint(lessThanOrEqualTo: blurView.bottomAnchor, constant: -32)
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
        
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
    }
}

