//
//  ZodiacHeaderView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class ZodiacHeaderView: UIView {
    
    @IBOutlet weak var zodiacIconView: UIView!
    @IBOutlet weak var zodiacSymbolLabel: UILabel!
    @IBOutlet weak var zodiacNameLabel: UILabel!
    @IBOutlet weak var zodiacSubtitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
        setupUI()
    }
    
    private func loadFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ZodiacHeaderView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func setupUI() {
        // Burç ikonu - gradient ve glow
        zodiacIconView.backgroundColor = .clear
        zodiacIconView.layer.cornerRadius = 32
        zodiacIconView.clipsToBounds = true
        
        // Gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        gradientLayer.cornerRadius = 32
        
        gradientLayer.colors = [
            UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1).cgColor, // Mor
            UIColor(red: 0.2, green: 0.4, blue: 0.9, alpha: 1).cgColor  // Mavi
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        zodiacIconView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Glow efekti
        zodiacIconView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.8).cgColor
        zodiacIconView.layer.shadowOffset = CGSize(width: 0, height: 0)
        zodiacIconView.layer.shadowRadius = 16
        zodiacIconView.layer.shadowOpacity = 1.0
        zodiacIconView.layer.masksToBounds = false
        
        // Burç simgesi
        zodiacSymbolLabel.text = "♓"
        zodiacSymbolLabel.font = .systemFont(ofSize: 36)
        zodiacSymbolLabel.textColor = .white
        zodiacSymbolLabel.textAlignment = .center
        
        // Metin stilleri
        zodiacNameLabel.text = "Balık"
        zodiacNameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        zodiacNameLabel.textColor = .white
        
        zodiacSubtitleLabel.text = "Bugün senin için"
        zodiacSubtitleLabel.font = .systemFont(ofSize: 15)
        zodiacSubtitleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
    }
    
    func configure(zodiacName: String, zodiacSymbol: String) {
        zodiacNameLabel.text = zodiacName
        zodiacSymbolLabel.text = zodiacSymbol
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Gradient layer'ı güncelle
        if let gradientLayer = zodiacIconView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = zodiacIconView.bounds
        }
    }
}

