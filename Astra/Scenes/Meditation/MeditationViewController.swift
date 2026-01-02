//
//  MeditationViewController.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class MeditationViewController: UIViewController {
    
    private let viewModel: MeditationViewModel
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var zodiacCardContainerView: UIView!
    @IBOutlet weak var zodiacCardBlurView: UIView!
    @IBOutlet weak var zodiacCardIconView: UIView!
    @IBOutlet weak var zodiacCardIconLabel: UILabel!
    @IBOutlet weak var zodiacCardTitleLabel: UILabel!
    @IBOutlet weak var zodiacCardSubtitleLabel: UILabel!
    @IBOutlet weak var zodiacCardDescriptionLabel: UILabel!
    @IBOutlet weak var zodiacCardPremiumBadge: UIView!
    @IBOutlet weak var zodiacCardPremiumLabel: UILabel!
    
    @IBOutlet weak var dailyCardContainerView: UIView!
    @IBOutlet weak var dailyCardBlurView: UIView!
    @IBOutlet weak var dailyCardIconView: UIView!
    @IBOutlet weak var dailyCardIconLabel: UILabel!
    @IBOutlet weak var dailyCardTitleLabel: UILabel!
    @IBOutlet weak var dailyCardSubtitleLabel: UILabel!
    @IBOutlet weak var dailyCardDescriptionLabel: UILabel!
    @IBOutlet weak var dailyCardPremiumBadge: UIView!
    @IBOutlet weak var dailyCardPremiumLabel: UILabel!
    
    private var zodiacGradientLayer: CAGradientLayer?
    private var dailyGradientLayer: CAGradientLayer?
    private var zodiacBlurEffectView: UIVisualEffectView?
    private var dailyBlurEffectView: UIVisualEffectView?
    
    init(viewModel: MeditationViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil ?? "MeditationViewController", bundle: nibBundleOrNil)
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
        // Ortak gradient arka plan
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
        // Navigation bar
        navigationItem.title = "Meditasyon"
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Navigation bar stil
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupCards() {
        let cards = viewModel.availableCards
        
        // Zodiac Card Setup
        setupZodiacCard(card: cards.first(where: { $0.id == "zodiac" }))
        
        // Daily Card Setup
        setupDailyCard(card: cards.first(where: { $0.id == "daily" }))
        
        // Card tap gestures
        let zodiacTap = UITapGestureRecognizer(target: self, action: #selector(zodiacCardTapped))
        zodiacCardContainerView?.addGestureRecognizer(zodiacTap)
        zodiacCardContainerView?.isUserInteractionEnabled = true
        
        let dailyTap = UITapGestureRecognizer(target: self, action: #selector(dailyCardTapped))
        dailyCardContainerView?.addGestureRecognizer(dailyTap)
        dailyCardContainerView?.isUserInteractionEnabled = true
    }
    
    private func setupZodiacCard(card: MeditationCard?) {
        guard let card = card else { return }
        
        // Container styling
        zodiacCardContainerView?.layer.cornerRadius = 28
        zodiacCardContainerView?.clipsToBounds = false
        zodiacCardContainerView?.backgroundColor = .clear
        
        // Shadow
        zodiacCardContainerView?.layer.shadowColor = UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 0.3).cgColor
        zodiacCardContainerView?.layer.shadowOffset = CGSize(width: 0, height: 8)
        zodiacCardContainerView?.layer.shadowRadius = 20
        zodiacCardContainerView?.layer.shadowOpacity = 1.0
        
        // Blur effect
        zodiacCardBlurView?.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        zodiacCardBlurView?.layer.cornerRadius = 28
        zodiacCardBlurView?.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = zodiacCardBlurView?.bounds ?? .zero
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = 28
        blurView.clipsToBounds = true
        zodiacCardBlurView?.insertSubview(blurView, at: 0)
        zodiacBlurEffectView = blurView
        
        // Icon with gradient
        zodiacCardIconView?.layer.cornerRadius = 30
        zodiacCardIconView?.clipsToBounds = true
        
        let iconGradient = CAGradientLayer()
        iconGradient.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        iconGradient.cornerRadius = 30
        iconGradient.colors = [
            UIColor(red: 0.6, green: 0.3, blue: 0.9, alpha: 1).cgColor,
            UIColor(red: 0.3, green: 0.5, blue: 1.0, alpha: 1).cgColor
        ]
        iconGradient.startPoint = CGPoint(x: 0, y: 0)
        iconGradient.endPoint = CGPoint(x: 1, y: 1)
        zodiacCardIconView?.layer.insertSublayer(iconGradient, at: 0)
        zodiacGradientLayer = iconGradient
        
        zodiacCardIconLabel?.text = "♓"
        zodiacCardIconLabel?.textColor = .white
        zodiacCardIconLabel?.font = .systemFont(ofSize: 32)
        zodiacCardIconLabel?.textAlignment = .center
        
        // Title
        zodiacCardTitleLabel?.text = card.title
        zodiacCardTitleLabel?.textColor = .white
        zodiacCardTitleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        
        // Subtitle
        zodiacCardSubtitleLabel?.text = card.subtitle
        zodiacCardSubtitleLabel?.textColor = viewModel.isPremiumUser ? UIColor.white.withAlphaComponent(0.7) : UIColor.systemYellow.withAlphaComponent(0.9)
        zodiacCardSubtitleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        // Description
        zodiacCardDescriptionLabel?.text = "Burcunun enerjisine uygun özel meditasyon deneyimi"
        zodiacCardDescriptionLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        zodiacCardDescriptionLabel?.font = .systemFont(ofSize: 15)
        zodiacCardDescriptionLabel?.numberOfLines = 0
        
        // Premium badge
        zodiacCardPremiumBadge?.layer.cornerRadius = 12
        zodiacCardPremiumBadge?.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
        zodiacCardPremiumBadge?.layer.borderWidth = 1.0
        zodiacCardPremiumBadge?.layer.borderColor = UIColor.systemYellow.withAlphaComponent(0.5).cgColor
        zodiacCardPremiumBadge?.isHidden = viewModel.isPremiumUser
        
        zodiacCardPremiumLabel?.text = "Premium"
        zodiacCardPremiumLabel?.textColor = UIColor.systemYellow
        zodiacCardPremiumLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        zodiacCardPremiumLabel?.isHidden = viewModel.isPremiumUser
    }
    
    private func setupDailyCard(card: MeditationCard?) {
        guard let card = card else { return }
        
        // Container styling
        dailyCardContainerView?.layer.cornerRadius = 28
        dailyCardContainerView?.clipsToBounds = false
        dailyCardContainerView?.backgroundColor = .clear
        
        // Shadow
        dailyCardContainerView?.layer.shadowColor = UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 0.3).cgColor
        dailyCardContainerView?.layer.shadowOffset = CGSize(width: 0, height: 8)
        dailyCardContainerView?.layer.shadowRadius = 20
        dailyCardContainerView?.layer.shadowOpacity = 1.0
        
        // Blur effect
        dailyCardBlurView?.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        dailyCardBlurView?.layer.cornerRadius = 28
        dailyCardBlurView?.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = dailyCardBlurView?.bounds ?? .zero
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = 28
        blurView.clipsToBounds = true
        dailyCardBlurView?.insertSubview(blurView, at: 0)
        dailyBlurEffectView = blurView
        
        // Icon with gradient
        dailyCardIconView?.layer.cornerRadius = 30
        dailyCardIconView?.clipsToBounds = true
        
        let iconGradient = CAGradientLayer()
        iconGradient.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        iconGradient.cornerRadius = 30
        iconGradient.colors = [
            UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1).cgColor,
            UIColor(red: 0.4, green: 0.8, blue: 0.9, alpha: 1).cgColor
        ]
        iconGradient.startPoint = CGPoint(x: 0, y: 0)
        iconGradient.endPoint = CGPoint(x: 1, y: 1)
        dailyCardIconView?.layer.insertSublayer(iconGradient, at: 0)
        dailyGradientLayer = iconGradient
        
        dailyCardIconLabel?.text = "⚡"
        dailyCardIconLabel?.textColor = .white
        dailyCardIconLabel?.font = .systemFont(ofSize: 32)
        dailyCardIconLabel?.textAlignment = .center
        
        // Title
        dailyCardTitleLabel?.text = card.title
        dailyCardTitleLabel?.textColor = .white
        dailyCardTitleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        
        // Subtitle
        dailyCardSubtitleLabel?.text = card.subtitle
        dailyCardSubtitleLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
        dailyCardSubtitleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        // Description
        dailyCardDescriptionLabel?.text = "Bugünün astrolojik enerjisine göre özel hazırlanmış meditasyon"
        dailyCardDescriptionLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        dailyCardDescriptionLabel?.font = .systemFont(ofSize: 15)
        dailyCardDescriptionLabel?.numberOfLines = 0
        
        // Premium badge (her zaman göster)
        dailyCardPremiumBadge?.layer.cornerRadius = 12
        dailyCardPremiumBadge?.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.2)
        dailyCardPremiumBadge?.layer.borderWidth = 1.0
        dailyCardPremiumBadge?.layer.borderColor = UIColor.systemYellow.withAlphaComponent(0.5).cgColor
        
        dailyCardPremiumLabel?.text = "Premium"
        dailyCardPremiumLabel?.textColor = UIColor.systemYellow
        dailyCardPremiumLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    @objc private func zodiacCardTapped() {
        if viewModel.canAccessZodiacMeditation() {
            // Kullanım sayısını artır
            viewModel.increaseZodiacMeditationUsage()
            
            // Meditasyon player'ı aç
            let playerVC = ZodiacMeditationPlayerViewController()
            navigationController?.pushViewController(playerVC, animated: true)
        } else {
            // Premium paywall'u aç
            let paywallVC = PremiumPaywallViewController()
            paywallVC.modalPresentationStyle = .fullScreen
            paywallVC.onPurchaseComplete = { [weak self] in
                // Premium satın alındığında view'ı güncelle
                self?.viewModel.load()
            }
            present(paywallVC, animated: true)
        }
    }
    
    @objc private func dailyCardTapped() {
        if viewModel.canAccessDailyMeditation() {
            // Günün enerjisi meditasyonu aç (placeholder)
            let alert = UIAlertController(title: "Günün Enerjisi Meditasyonu", message: "Bu özellik yakında eklenecek.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true)
        } else {
            // Premium paywall'u aç
            let paywallVC = PremiumPaywallViewController()
            paywallVC.modalPresentationStyle = .fullScreen
            paywallVC.onPurchaseComplete = { [weak self] in
                // Premium satın alındığında view'ı güncelle
                self?.viewModel.load()
            }
            present(paywallVC, animated: true)
        }
    }
    
    private func setupViewModel() {
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateCards()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                print("Hata: \(errorMessage)")
            }
        }
        
        viewModel.load()
    }
    
    private func updateCards() {
        let cards = viewModel.availableCards
        
        if let zodiacCard = cards.first(where: { $0.id == "zodiac" }) {
            zodiacCardSubtitleLabel?.text = zodiacCard.subtitle
            zodiacCardSubtitleLabel?.textColor = viewModel.isPremiumUser ? UIColor.white.withAlphaComponent(0.7) : UIColor.systemYellow.withAlphaComponent(0.9)
            
            // Premium badge'i güncelle
            zodiacCardPremiumBadge?.isHidden = viewModel.isPremiumUser
            zodiacCardPremiumLabel?.isHidden = viewModel.isPremiumUser
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Background gradient layer'ı güncelle
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
        
        // Icon gradient layers'ı güncelle
        if let iconView = zodiacCardIconView {
            zodiacGradientLayer?.frame = iconView.bounds
        }
        
        if let iconView = dailyCardIconView {
            dailyGradientLayer?.frame = iconView.bounds
        }
        
        // Blur effect views'ı güncelle
        zodiacBlurEffectView?.frame = zodiacCardBlurView?.bounds ?? .zero
        dailyBlurEffectView?.frame = dailyCardBlurView?.bounds ?? .zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ViewModel'i güncelle (kullanım sayısı değişmiş olabilir)
        viewModel.load()
    }
}

