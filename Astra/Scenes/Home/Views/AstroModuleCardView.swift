//
//  AstroModuleCardView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class AstroModuleCardView: UICollectionViewCell {
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var blurContainerView: UIView!
    @IBOutlet weak var cardContainerView: UIView!
    
    private var blurEffectView: UIVisualEffectView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // EN DIŞ KART VIEW - Tam yuvarlak
        cardContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.1) // Glassmorphism için yarı saydam
        cardContainerView.clipsToBounds = false // Shadow için
        
        // Shadow efekti - EN DIŞ VIEW'da
        cardContainerView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.25).cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardContainerView.layer.shadowRadius = 12
        cardContainerView.layer.shadowOpacity = 1.0
        
        // Blur container - arka plan şeffaf
        blurContainerView.backgroundColor = .clear
        
        // Glassmorphism efekti - blur view
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurContainerView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.clipsToBounds = true
        blurContainerView.insertSubview(blurView, at: 0)
        blurEffectView = blurView
        
        // Metin stilleri
        iconLabel?.textColor = .white
        iconLabel?.font = .systemFont(ofSize: 36)
        
        titleLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        
        valueLabel?.textColor = .white
        valueLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // EN DIŞ KART VIEW - Tam yuvarlak (height / 2)
        let cornerRadius = cardContainerView.bounds.height / 2
        cardContainerView.layer.cornerRadius = cornerRadius
        
        // Shadow path - yuvarlak shadow için
        cardContainerView.layer.shadowPath = UIBezierPath(
            roundedRect: cardContainerView.bounds,
            cornerRadius: cornerRadius
        ).cgPath
        
        // Blur view'ı güncelle
        if let blurView = blurEffectView {
            blurView.frame = blurContainerView.bounds
            // Blur view'ın corner radius'u da cardContainerView ile aynı olmalı
            blurView.layer.cornerRadius = cornerRadius
        }
    }
    
    func configure(icon: String, title: String, value: String) {
        iconLabel?.text = icon
        titleLabel?.text = title
        valueLabel?.text = value
    }
}
