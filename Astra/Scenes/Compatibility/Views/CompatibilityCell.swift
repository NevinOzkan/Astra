//
//  CompatibilityCell.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class CompatibilityCell: UICollectionViewCell {
    
    @IBOutlet weak var zodiacIconView: UIView!
    @IBOutlet weak var zodiacSymbolLabel: UILabel!
    @IBOutlet weak var zodiacNameLabel: UILabel!
    @IBOutlet weak var loveProgressContainerView: UIView!
    @IBOutlet weak var friendshipProgressContainerView: UIView!
    @IBOutlet weak var workProgressContainerView: UIView!
    @IBOutlet weak var blurContainerView: UIView!
    @IBOutlet weak var cardContainerView: UIView!
    
    private var blurEffectView: UIVisualEffectView?
    private var gradientLayer: CAGradientLayer?
    private var loveProgressView: CompatibilityProgressView?
    private var friendshipProgressView: CompatibilityProgressView?
    private var workProgressView: CompatibilityProgressView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Glassmorphism efekti
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurContainerView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = 24  // Corner radius artırıldı
        blurView.clipsToBounds = true
        blurContainerView.insertSubview(blurView, at: 0)
        blurEffectView = blurView
        
        blurContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        // Kart container stil - daha büyük corner radius ve daha yumuşak shadow
        cardContainerView.backgroundColor = .clear
        cardContainerView.layer.cornerRadius = 24  // Artırıldı
        cardContainerView.clipsToBounds = false
        
        // Shadow efekti - daha yumuşak ve yaygın
        cardContainerView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.2).cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cardContainerView.layer.shadowRadius = 16  // Artırıldı
        cardContainerView.layer.shadowOpacity = 1.0
        
        // Zodiac icon view - gradient
        zodiacIconView.backgroundColor = .clear
        zodiacIconView.layer.cornerRadius = 20
        zodiacIconView.clipsToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        gradient.cornerRadius = 20
        gradient.colors = [
            UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1).cgColor,
            UIColor(red: 0.2, green: 0.4, blue: 0.9, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        zodiacIconView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Metin stilleri
        zodiacSymbolLabel?.textColor = .white
        zodiacSymbolLabel?.font = .systemFont(ofSize: 20)
        zodiacSymbolLabel?.textAlignment = .center
        
        zodiacNameLabel?.textColor = .white
        zodiacNameLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        // Progress view'ları programatik olarak ekle
        setupProgressViews()
    }
    
    private func setupProgressViews() {
        // Love Progress View - label'dan sonra başlasın
        let loveProgress = CompatibilityProgressView()
        loveProgress.translatesAutoresizingMaskIntoConstraints = false
        loveProgressContainerView.addSubview(loveProgress)
        NSLayoutConstraint.activate([
            loveProgress.leadingAnchor.constraint(equalTo: loveProgressContainerView.leadingAnchor, constant: 50),
            loveProgress.trailingAnchor.constraint(equalTo: loveProgressContainerView.trailingAnchor),
            loveProgress.topAnchor.constraint(equalTo: loveProgressContainerView.topAnchor),
            loveProgress.bottomAnchor.constraint(equalTo: loveProgressContainerView.bottomAnchor)
        ])
        loveProgressView = loveProgress
        
        // Friendship Progress View
        let friendshipProgress = CompatibilityProgressView()
        friendshipProgress.translatesAutoresizingMaskIntoConstraints = false
        friendshipProgressContainerView.addSubview(friendshipProgress)
        NSLayoutConstraint.activate([
            friendshipProgress.leadingAnchor.constraint(equalTo: friendshipProgressContainerView.leadingAnchor, constant: 90),
            friendshipProgress.trailingAnchor.constraint(equalTo: friendshipProgressContainerView.trailingAnchor),
            friendshipProgress.topAnchor.constraint(equalTo: friendshipProgressContainerView.topAnchor),
            friendshipProgress.bottomAnchor.constraint(equalTo: friendshipProgressContainerView.bottomAnchor)
        ])
        friendshipProgressView = friendshipProgress
        
        // Work Progress View
        let workProgress = CompatibilityProgressView()
        workProgress.translatesAutoresizingMaskIntoConstraints = false
        workProgressContainerView.addSubview(workProgress)
        NSLayoutConstraint.activate([
            workProgress.leadingAnchor.constraint(equalTo: workProgressContainerView.leadingAnchor, constant: 35),
            workProgress.trailingAnchor.constraint(equalTo: workProgressContainerView.trailingAnchor),
            workProgress.topAnchor.constraint(equalTo: workProgressContainerView.topAnchor),
            workProgress.bottomAnchor.constraint(equalTo: workProgressContainerView.bottomAnchor)
        ])
        workProgressView = workProgress
    }
    
    func configure(compatibility: Compatibility) {
        // Burç bilgisini bul
        guard let sign = ZodiacSign.allSigns.first(where: { $0.name == compatibility.sign }) else { return }
        
        zodiacSymbolLabel?.text = sign.symbol
        zodiacNameLabel?.text = sign.name
        
        // Progress view'ları yapılandır
        loveProgressView?.progress = Float(compatibility.love) / 100.0
        loveProgressView?.valueText = "%\(compatibility.love)"
        loveProgressView?.gradientColors = [UIColor.systemPink, UIColor.systemPurple]
        
        friendshipProgressView?.progress = Float(compatibility.friendship) / 100.0
        friendshipProgressView?.valueText = "%\(compatibility.friendship)"
        friendshipProgressView?.gradientColors = [UIColor.systemBlue, UIColor.systemCyan]
        
        workProgressView?.progress = Float(compatibility.work) / 100.0
        workProgressView?.valueText = "%\(compatibility.work)"
        workProgressView?.gradientColors = [UIColor.systemOrange, UIColor.systemYellow]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Blur view'ı güncelle
        if let blurView = blurEffectView {
            blurView.frame = blurContainerView.bounds
        }
        
        // Gradient layer'ı güncelle
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = zodiacIconView.bounds
        }
    }
}

