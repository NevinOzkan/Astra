//
//  PremiumPreviewView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class PremiumPreviewView: UIView {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let blurEffectView = UIVisualEffectView()
    private let lockIconLabel = UILabel()
    private let titleLabel = UILabel()
    private let contentStackView = UIStackView()
    private let ctaButton = UIButton(type: .system)
    
    // Premium content views
    private let loveSectionView = UIView()
    private let loveTitleLabel = UILabel()
    private let loveContentLabel = UILabel()
    private let workSectionView = UIView()
    private let workTitleLabel = UILabel()
    private let workContentLabel = UILabel()
    private let ritualSectionView = UIView()
    private let ritualTitleLabel = UILabel()
    private let ritualContentLabel = UILabel()
    
    var onTap: (() -> Void)?
    var isPremium: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    var premiumContent: (love: String, work: String, ritual: String)? {
        didSet {
            updateContent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // Container view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 24
        containerView.clipsToBounds = true
        
        // Blur effect
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        blurEffectView.effect = blurEffect
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        containerView.insertSubview(blurEffectView, at: 0)
        
        // Lock icon
        lockIconLabel.text = "🔒"
        lockIconLabel.font = .systemFont(ofSize: 20)
        lockIconLabel.textAlignment = .center
        lockIconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        titleLabel.text = "Premium'da Seni Bekleyenler"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Content stack view
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.spacing = 20
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Premium content sections ve preview items hazırla
        setupPremiumSections()
        setupPreviewItems()
        
        // İlk durumu ayarla
        updateUI()
        
        // CTA Button
        ctaButton.setTitle("Premium ile keşfet", for: .normal)
        ctaButton.backgroundColor = UIColor.systemBlue
        ctaButton.layer.cornerRadius = 12
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        ctaButton.addTarget(self, action: #selector(ctaButtonTapped), for: .touchUpInside)
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add subviews
        addSubview(containerView)
        containerView.addSubview(lockIconLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentStackView)
        containerView.addSubview(ctaButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Container
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Blur effect
            blurEffectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Lock icon
            lockIconLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            lockIconLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            lockIconLabel.widthAnchor.constraint(equalToConstant: 28),
            lockIconLabel.heightAnchor.constraint(equalToConstant: 28),
            
            // Title
            titleLabel.leadingAnchor.constraint(equalTo: lockIconLabel.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: lockIconLabel.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Content stack
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            contentStackView.topAnchor.constraint(equalTo: lockIconLabel.bottomAnchor, constant: 20),
            
            // CTA Button
            ctaButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            ctaButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            ctaButton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 20),
            ctaButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            ctaButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Shadow efekti
        containerView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.15).cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 1.0
    }
    
    private func setupPremiumSections() {
        // Love section
        setupSection(
            container: loveSectionView,
            emoji: "❤️",
            title: "Aşk & İlişkiler",
            contentLabel: loveContentLabel,
            titleLabel: loveTitleLabel
        )
        
        // Work section
        setupSection(
            container: workSectionView,
            emoji: "💼",
            title: "İş & Kararlar",
            contentLabel: workContentLabel,
            titleLabel: workTitleLabel
        )
        
        // Ritual section
        setupSection(
            container: ritualSectionView,
            emoji: "🪄",
            title: "Ay Evresine Özel Ritüel",
            contentLabel: ritualContentLabel,
            titleLabel: ritualTitleLabel
        )
        
        contentStackView.addArrangedSubview(loveSectionView)
        contentStackView.addArrangedSubview(workSectionView)
        contentStackView.addArrangedSubview(ritualSectionView)
    }
    
    private func setupSection(
        container: UIView,
        emoji: String,
        title: String,
        contentLabel: UILabel,
        titleLabel: UILabel
    ) {
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = .systemFont(ofSize: 20)
        emojiLabel.textAlignment = .center
        emojiLabel.setContentHuggingPriority(.required, for: .horizontal)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        contentLabel.font = .systemFont(ofSize: 15, weight: .regular)
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(emojiLabel)
        container.addSubview(titleLabel)
        container.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            emojiLabel.topAnchor.constraint(equalTo: container.topAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 28),
            
            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            contentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            contentLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            contentLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    private var titleLeadingConstraint: NSLayoutConstraint?
    
    private func updateUI() {
        // Blur effect - sadece free kullanıcılar için
        blurEffectView.isHidden = isPremium
        
        // Lock icon - sadece free kullanıcılar için
        lockIconLabel.isHidden = isPremium
        
        // Title - free kullanıcılar için preview başlığı, premium için içerik başlığı
        if isPremium {
            titleLabel.text = "Premium İçerik"
            // Lock icon gizli olduğu için title'ı sola hizala
            // Mevcut constraint'i bul ve deaktif et
            let existingConstraints = containerView.constraints.filter { constraint in
                return constraint.firstItem === titleLabel && 
                       constraint.firstAttribute == .leading &&
                       constraint.secondItem === lockIconLabel
            }
            existingConstraints.forEach { $0.isActive = false }
            
            // Yeni constraint oluştur
            titleLeadingConstraint?.isActive = false
            titleLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20)
            titleLeadingConstraint?.isActive = true
        } else {
            titleLabel.text = "Premium'da Seni Bekleyenler"
            // Lock icon görünür olduğu için eski constraint'i geri getir
            titleLeadingConstraint?.isActive = false
            // XIB'deki constraint zaten aktif olacak
        }
        
        // CTA Button - sadece free kullanıcılar için
        ctaButton.isHidden = isPremium
        
        // Content visibility
        if isPremium {
            // Premium içerik göster (section'lar)
            loveSectionView.isHidden = false
            workSectionView.isHidden = false
            ritualSectionView.isHidden = false
            
            // Preview items gizle
            hidePreviewItems()
        } else {
            // Preview items göster
            showPreviewItems()
            
            // Premium section'ları gizle
            loveSectionView.isHidden = true
            workSectionView.isHidden = true
            ritualSectionView.isHidden = true
        }
    }
    
    private var previewItems: [UIView] = []
    
    private func showPreviewItems() {
        // Premium section'ları gizle
        loveSectionView.isHidden = true
        workSectionView.isHidden = true
        ritualSectionView.isHidden = true
        
        // Preview items'ları göster
        previewItems.forEach { $0.isHidden = false }
    }
    
    private func hidePreviewItems() {
        // Preview items'ları gizle
        previewItems.forEach { $0.isHidden = true }
        
        // Premium section'ları göster
        loveSectionView.isHidden = false
        workSectionView.isHidden = false
        ritualSectionView.isHidden = false
    }
    
    private func setupPreviewItems() {
        // Preview items
        let previewItemsData = [
            ("❤️", "Aşk & ilişkiler üzerindeki etkiler"),
            ("💼", "İş, kararlar ve odak alanları"),
            ("🪄", "Ay evresine özel mini ritüel")
        ]
        
        previewItems = previewItemsData.map { createPreviewItem(emoji: $0.0, text: $0.1) }
        
        // Stack view'a ekle (ama başlangıçta gizli)
        previewItems.forEach { itemView in
            itemView.isHidden = true
            contentStackView.addArrangedSubview(itemView)
        }
    }
    
    private func createPreviewItem(emoji: String, text: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = .systemFont(ofSize: 18)
        emojiLabel.textAlignment = .center
        emojiLabel.setContentHuggingPriority(.required, for: .horizontal)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        textLabel.font = .systemFont(ofSize: 15, weight: .regular)
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(emojiLabel)
        containerView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            emojiLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            
            textLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func updateContent() {
        guard let content = premiumContent else { return }
        
        loveContentLabel.text = content.love
        workContentLabel.text = content.work
        ritualContentLabel.text = content.ritual
    }
    
    @objc private func ctaButtonTapped() {
        onTap?()
    }
    
    // Tap gesture for whole view
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTapped() {
        onTap?()
    }
}

