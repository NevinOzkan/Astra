//
//  CompatibilityRowView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class CompatibilityRowView: UIView {
    
    @IBOutlet weak var zodiacIconView: UIView!
    @IBOutlet weak var zodiacSymbolLabel: UILabel!
    @IBOutlet weak var zodiacNameLabel: UILabel!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    private var progressView: CompatibilityProgressView?
    private var gradientLayer: CAGradientLayer?
    
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
        let nib = UINib(nibName: "CompatibilityRowView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // Zodiac icon - küçük daire
        zodiacIconView.backgroundColor = .clear
        zodiacIconView.clipsToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
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
        zodiacSymbolLabel?.font = .systemFont(ofSize: 16)
        zodiacSymbolLabel?.textAlignment = .center
        
        zodiacNameLabel?.textColor = .white
        zodiacNameLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        percentageLabel?.textColor = .white
        percentageLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        percentageLabel?.textAlignment = .right
        
        // Progress view - value label olmadan
        let progress = CompatibilityProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.valueText = ""  // Value label kullanmıyoruz, percentage label var
        progressContainerView.addSubview(progress)
        NSLayoutConstraint.activate([
            progress.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor),
            progress.topAnchor.constraint(equalTo: progressContainerView.topAnchor),
            progress.bottomAnchor.constraint(equalTo: progressContainerView.bottomAnchor)
        ])
        progressView = progress
    }
    
    func configure(sign: ZodiacSign, percentage: Int, gradientColors: [UIColor]) {
        zodiacSymbolLabel?.text = sign.symbol
        zodiacNameLabel?.text = sign.name
        percentageLabel?.text = "%\(percentage)"
        
        progressView?.progress = Float(percentage) / 100.0
        progressView?.valueText = ""
        progressView?.gradientColors = gradientColors
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Tam daire yap
        let cornerRadius = zodiacIconView.bounds.width / 2
        zodiacIconView.layer.cornerRadius = cornerRadius
        
        // Gradient layer'ı güncelle
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = zodiacIconView.bounds
            gradientLayer.cornerRadius = cornerRadius
        }
    }
}

