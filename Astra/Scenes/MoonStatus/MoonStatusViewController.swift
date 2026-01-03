//
//  MoonStatusViewController.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class MoonStatusViewController: UIViewController {
    
    private let viewModel: MoonStatusViewModel
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var moonIconLabel: UILabel!
    @IBOutlet weak var phaseNameLabel: UILabel!
    @IBOutlet weak var effectDurationLabel: UILabel!
    @IBOutlet weak var descriptionContainerView: UIView!
    @IBOutlet weak var freeDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var premiumBlurView: UIView!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var impactAreasContainerView: UIView!
    @IBOutlet weak var impactAreasTitleLabel: UILabel!
    @IBOutlet weak var impactAreasStackView: UIStackView!
    
    private var blurEffectView: UIVisualEffectView?
    private var descriptionBlurEffectView: UIVisualEffectView?
    private var descriptionLabelTopConstraint: NSLayoutConstraint?
    private var premiumPreviewView: PremiumPreviewView?
    private var descriptionContainerHeightConstraint: NSLayoutConstraint?
    
    init(viewModel: MoonStatusViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil ?? "MoonStatusViewController", bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupUI()
        setupContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Ay görseline hafif pulse animasyonu başlat
        startMoonPulseAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation bar
        navigationItem.title = "Ayın Durumu"
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
    
    private func setupBackground() {
        // Gradient arka plan
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
        view.backgroundColor = .clear
        
        // Moon icon
        moonIconLabel?.text = viewModel.phaseEmoji
        moonIconLabel?.font = .systemFont(ofSize: 80)
        moonIconLabel?.textAlignment = .center
        
        // Phase name
        phaseNameLabel?.text = viewModel.phaseName
        phaseNameLabel?.textColor = .white
        phaseNameLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        phaseNameLabel?.textAlignment = .center
        
        // Effect duration (hem free hem premium için göster)
        effectDurationLabel?.text = viewModel.effectDuration
        effectDurationLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
        effectDurationLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        effectDurationLabel?.textAlignment = .center
        effectDurationLabel?.numberOfLines = 0
        
        // Description container - kart görünümü
        setupDescriptionContainer()
        
        // Free description (her zaman göster)
        freeDescriptionLabel?.text = viewModel.freeDescription
        freeDescriptionLabel?.textColor = UIColor.white.withAlphaComponent(0.9)
        freeDescriptionLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        freeDescriptionLabel?.numberOfLines = 0
        freeDescriptionLabel?.textAlignment = .left
        freeDescriptionLabel?.setContentHuggingPriority(.defaultLow, for: .vertical)
        freeDescriptionLabel?.setContentCompressionResistancePriority(.required, for: .vertical)
        
        // Premium description (premium kullanıcılar için göster)
        descriptionLabel?.text = viewModel.premiumDescription
        descriptionLabel?.textColor = UIColor.white.withAlphaComponent(0.9)
        descriptionLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel?.numberOfLines = 0
        descriptionLabel?.textAlignment = .left
        descriptionLabel?.setContentHuggingPriority(.defaultLow, for: .vertical)
        descriptionLabel?.setContentCompressionResistancePriority(.required, for: .vertical)
        descriptionLabel?.isHidden = true // Başlangıçta gizli, setupContent'te ayarlanacak
        
        // Premium blur view ve button artık kullanılmıyor - premium kart kendi blur'unu yönetiyor
        premiumBlurView?.isHidden = true
        premiumButton?.isHidden = true
        
        // Impact areas setup
        setupImpactAreas()
    }
    
    private func setupImpactAreas() {
        // Başlık
        impactAreasTitleLabel?.text = "Bu Ay Evresinin Etki Alanları"
        impactAreasTitleLabel?.textColor = .white
        impactAreasTitleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        impactAreasTitleLabel?.textAlignment = .left
        
        // Stack view ayarları
        impactAreasStackView?.axis = .vertical
        impactAreasStackView?.alignment = .fill
        impactAreasStackView?.distribution = .fill
        impactAreasStackView?.spacing = 12
        
        // Container view stil
        impactAreasContainerView?.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        impactAreasContainerView?.layer.cornerRadius = 24
        impactAreasContainerView?.clipsToBounds = true
        
        // Blur effect
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        impactAreasContainerView?.insertSubview(blurView, at: 0)
        
        if let container = impactAreasContainerView {
            NSLayoutConstraint.activate([
                blurView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                blurView.topAnchor.constraint(equalTo: container.topAnchor),
                blurView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
        
        // Shadow efekti
        impactAreasContainerView?.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.15).cgColor
        impactAreasContainerView?.layer.shadowOffset = CGSize(width: 0, height: 4)
        impactAreasContainerView?.layer.shadowRadius = 8
        impactAreasContainerView?.layer.shadowOpacity = 1.0
    }
    
    private func setupDescriptionContainer() {
        guard let container = descriptionContainerView else { return }
        
        // Glassmorphism efekti
        container.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        container.layer.cornerRadius = 24
        container.clipsToBounds = true
        
        // Blur effect
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        descriptionBlurEffectView = UIVisualEffectView(effect: blurEffect)
        guard let blurView = descriptionBlurEffectView else { return }
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        container.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: container.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        // Shadow efekti
        container.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.15).cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        container.layer.shadowRadius = 8
        container.layer.shadowOpacity = 1.0
    }
    
    private func setupPremiumBlurView() {
        guard let blurView = premiumBlurView else { return }
        
        if viewModel.isPremiumUser {
            // Premium kullanıcı - blur view gizle
            blurView.isHidden = true
            premiumButton?.isHidden = true
        } else {
            // Free kullanıcı - blur view göster ve premium içeriği kilitle
            blurView.isHidden = false
            premiumButton?.isHidden = false
            
            // Blur effect - description container'ın üzerine gelir
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            guard let blurEffectView = blurEffectView else { return }
            
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
            blurView.addSubview(blurEffectView)
            
            NSLayoutConstraint.activate([
                blurEffectView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
                blurEffectView.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
                blurEffectView.topAnchor.constraint(equalTo: blurView.topAnchor),
                blurEffectView.bottomAnchor.constraint(equalTo: blurView.bottomAnchor)
            ])
            
            // Premium label
            premiumLabel?.text = "Premium içerik"
            premiumLabel?.textColor = .white
            premiumLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            premiumLabel?.textAlignment = .center
            
            // Free kullanıcı için tek cümle göster (üstte küçük bir alan)
            // Bu kısım description label'ın üstünde gösterilebilir veya ayrı bir label olabilir
            // Şimdilik blur view içinde premium label ve button var
        }
    }
    
    private func setupContent() {
        // İçeriği güncelle
        moonIconLabel?.text = viewModel.phaseEmoji
        phaseNameLabel?.text = viewModel.phaseName
        
        // Effect duration (hem free hem premium için göster)
        effectDurationLabel?.text = viewModel.effectDuration
        
        // Premium durumuna göre üst kısım içeriğini ve kart boyutunu ayarla
        if viewModel.isPremiumUser {
            // Premium kullanıcı - uzun paragraf göster, kart büyük olmalı
            freeDescriptionLabel?.isHidden = true
            descriptionLabel?.isHidden = false
            descriptionLabel?.text = viewModel.premiumDescription
            
            // Description container'ı büyük yap (uzun paragraf için)
            if let container = descriptionContainerView {
                // Mevcut height constraint'i bul ve deaktif et
                let existingHeightConstraints = container.constraints.filter { constraint in
                    return constraint.firstAttribute == .height && constraint.firstItem === container
                }
                existingHeightConstraints.forEach { $0.isActive = false }
                
                // Yeni büyük height constraint oluştur
                descriptionContainerHeightConstraint?.isActive = false
                descriptionContainerHeightConstraint = container.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
                descriptionContainerHeightConstraint?.isActive = true
            }
            
            // Premium description'ın top constraint'ini description container'a bağla
            if let descriptionLabel = descriptionLabel,
               let container = descriptionContainerView {
                // XIB'deki mevcut constraint'i bul ve deaktif et
                let existingConstraints = container.constraints.filter { constraint in
                    return constraint.firstItem === descriptionLabel && 
                           constraint.firstAttribute == .top &&
                           constraint.secondItem === freeDescriptionLabel
                }
                existingConstraints.forEach { $0.isActive = false }
                
                // Yeni constraint oluştur
                descriptionLabelTopConstraint?.isActive = false
                descriptionLabelTopConstraint = descriptionLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20)
                descriptionLabelTopConstraint?.isActive = true
            }
        } else {
            // Free kullanıcı - tek cümle göster ve ortala, kart küçük olmalı
            freeDescriptionLabel?.isHidden = false
            freeDescriptionLabel?.text = viewModel.freeDescription
            descriptionLabel?.isHidden = true
            
            // Description container'ı küçük yap (tek cümle için)
            if let container = descriptionContainerView {
                // Mevcut height constraint'i bul ve deaktif et
                let existingHeightConstraints = container.constraints.filter { constraint in
                    return constraint.firstAttribute == .height && constraint.firstItem === container
                }
                existingHeightConstraints.forEach { $0.isActive = false }
                
                // Yeni küçük height constraint oluştur
                descriptionContainerHeightConstraint?.isActive = false
                descriptionContainerHeightConstraint = container.heightAnchor.constraint(equalToConstant: 120)
                descriptionContainerHeightConstraint?.isActive = true
            }
            
            // Free description'ı container içinde dikey olarak ortala
            if let freeLabel = freeDescriptionLabel,
               let container = descriptionContainerView {
                // Mevcut top constraint'i bul ve deaktif et
                let existingTopConstraints = container.constraints.filter { constraint in
                    return constraint.firstItem === freeLabel && 
                           constraint.firstAttribute == .top &&
                           constraint.secondItem === container
                }
                existingTopConstraints.forEach { $0.isActive = false }
                
                // Center Y constraint ekle
                freeLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
                
                // Leading ve trailing constraint'leri koru (zaten XIB'de var)
            }
            
            // Free description'ın top constraint'ini aktif et
            descriptionLabelTopConstraint?.isActive = false
            descriptionLabelTopConstraint = nil
        }
        
        // Premium blur view ve button artık kullanılmıyor
        premiumBlurView?.isHidden = true
        premiumButton?.isHidden = true
        
        // Premium kartını ayarla (hem free hem premium için)
        setupPremiumCard()
        
        // Layout'u güncelle
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func setupPremiumCard() {
        // Eğer zaten varsa kaldır
        premiumPreviewView?.removeFromSuperview()
        
        // Premium kartını oluştur
        let premiumCard = PremiumPreviewView()
        premiumCard.translatesAutoresizingMaskIntoConstraints = false
        premiumCard.isPremium = viewModel.isPremiumUser
        premiumCard.premiumContent = viewModel.premiumContent
        
        if viewModel.isPremiumUser {
            // Premium kullanıcı - tap gesture yok
            premiumCard.onTap = nil
        } else {
            // Free kullanıcı - tap gesture ile paywall aç
            premiumCard.onTap = { [weak self] in
                self?.openPremiumPaywall()
            }
        }
        
        contentView.addSubview(premiumCard)
        premiumPreviewView = premiumCard
        
        // Constraints - description container'ın altına ekle
        // Önce mevcut bottom constraint'leri bul ve deaktif et
        let existingBottomConstraints = contentView.constraints.filter { constraint in
            return constraint.firstAttribute == .bottom && 
                   (constraint.secondItem === descriptionContainerView || 
                    constraint.firstItem === descriptionContainerView ||
                    constraint.secondItem === impactAreasContainerView ||
                    constraint.firstItem === impactAreasContainerView)
        }
        existingBottomConstraints.forEach { $0.isActive = false }
        
        // Impact areas container'ı gizle (artık premium kart içinde)
        impactAreasContainerView?.isHidden = true
        
        NSLayoutConstraint.activate([
            premiumCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            premiumCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            premiumCard.topAnchor.constraint(equalTo: descriptionContainerView.bottomAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: premiumCard.bottomAnchor, constant: 36)
        ])
    }
    
    private func openPremiumPaywall() {
        let paywallVC = PremiumPaywallViewController()
        paywallVC.modalPresentationStyle = .fullScreen
        paywallVC.onPurchaseComplete = { [weak self] in
            // Premium satın alındıktan sonra içeriği güncelle
            self?.setupContent()
        }
        present(paywallVC, animated: true)
    }
    
    private func setupImpactAreasContent() {
        guard let stackView = impactAreasStackView else { return }
        
        // Mevcut subview'ları temizle
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Etki alanlarını oluştur
        let impactAreas = viewModel.impactAreas
        
        for area in impactAreas {
            let chipView = createImpactAreaChip(emoji: area.emoji, title: area.title)
            stackView.addArrangedSubview(chipView)
        }
    }
    
    private func createImpactAreaChip(emoji: String, title: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 12
        horizontalStack.distribution = .fill
        
        // Emoji label
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = .systemFont(ofSize: 20)
        emojiLabel.textAlignment = .center
        emojiLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        // Title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        titleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel.numberOfLines = 0
        
        horizontalStack.addArrangedSubview(emojiLabel)
        horizontalStack.addArrangedSubview(titleLabel)
        
        containerView.addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            horizontalStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            horizontalStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
        
        return containerView
    }
    
    @objc private func premiumButtonTapped() {
        // Premium paywall aç
        let paywallVC = PremiumPaywallViewController()
        paywallVC.modalPresentationStyle = .fullScreen
        paywallVC.onPurchaseComplete = { [weak self] in
            // Premium satın alındıktan sonra içeriği güncelle
            // ViewModel zaten PremiumManager'dan okuyor, sadece setupContent'i çağırmak yeterli
            self?.setupContent()
        }
        present(paywallVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Gradient layer'ı güncelle
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    private func startMoonPulseAnimation() {
        guard let moonLabel = moonIconLabel else { return }
        
        // Opacity animasyonu: 0.95 ↔ 1.0 arasında yavaş pulse
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.95
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 2.5 // Yavaş pulse için uzun süre
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        moonLabel.layer.add(pulseAnimation, forKey: "moonPulse")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Animasyonu durdur
        moonIconLabel?.layer.removeAnimation(forKey: "moonPulse")
    }
}

