//
//  ZodiacSelectionCell.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class ZodiacSelectionCell: UICollectionViewCell {
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardContainerView: UIView!
    
    private var gradientLayer: CAGradientLayer?
    private var isSelectedState: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Icon view - tam daire olmalı
        iconView.backgroundColor = .clear
        iconView.clipsToBounds = true
        
        // Gradient background
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        gradient.colors = [
            UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1).cgColor, // Mor
            UIColor(red: 0.2, green: 0.4, blue: 0.9, alpha: 1).cgColor  // Mavi
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        iconView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
        
        // Metin stilleri
        symbolLabel?.textColor = .white
        symbolLabel?.font = .systemFont(ofSize: 28)
        symbolLabel?.textAlignment = .center
        
        nameLabel?.textColor = .white
        nameLabel?.font = .systemFont(ofSize: 11, weight: .medium)
        nameLabel?.textAlignment = .center
        
        // Card container
        cardContainerView.backgroundColor = .clear
        cardContainerView.clipsToBounds = false
    }
    
    func configure(sign: ZodiacSign, isSelected: Bool) {
        symbolLabel?.text = sign.symbol
        nameLabel?.text = sign.name
        isSelectedState = isSelected
        updateSelectionState()
    }
    
    private func updateSelectionState() {
        if isSelectedState {
            // Seçili durum - glow ve border
            iconView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.9).cgColor
            iconView.layer.shadowOffset = CGSize(width: 0, height: 0)
            iconView.layer.shadowRadius = 16
            iconView.layer.shadowOpacity = 1.0
            iconView.layer.borderWidth = 2
            iconView.layer.borderColor = UIColor(red: 0.8, green: 0.6, blue: 1.0, alpha: 1.0).cgColor
            iconView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            nameLabel?.alpha = 1.0
            nameLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
        } else {
            // Seçili değil - daha soluk
            iconView.layer.shadowOpacity = 0.0
            iconView.layer.borderWidth = 0
            iconView.transform = .identity
            nameLabel?.alpha = 0.6
            nameLabel?.font = .systemFont(ofSize: 11, weight: .medium)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Tam daire yap
        let cornerRadius = iconView.bounds.width / 2
        iconView.layer.cornerRadius = cornerRadius
        
        // Shadow path - tam daire için
        iconView.layer.shadowPath = UIBezierPath(ovalIn: iconView.bounds).cgPath
        
        // Gradient layer'ı güncelle
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = iconView.bounds
            gradientLayer.cornerRadius = cornerRadius
        }
    }
}

