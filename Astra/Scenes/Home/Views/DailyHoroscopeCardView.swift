//
//  DailyHoroscopeCardView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class DailyHoroscopeCardView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var blurEffectContainer: UIView!
    @IBOutlet weak var cardContainer: UIView!
    
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
        let nib = UINib(nibName: "DailyHoroscopeCardView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func setupUI() {
        // Glassmorphism efekti
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurEffectContainer.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 28
        blurEffectView.clipsToBounds = true
        
        blurEffectContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        blurEffectContainer.insertSubview(blurEffectView, at: 0)
        
        // Kart container stil
        cardContainer.backgroundColor = .clear
        cardContainer.layer.cornerRadius = 28
        cardContainer.clipsToBounds = false
        
        // Shadow efekti
        cardContainer.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.2).cgColor
        cardContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardContainer.layer.shadowRadius = 20
        cardContainer.layer.shadowOpacity = 1.0
        
        // Metin stilleri
        titleLabel.text = "Bugün"
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        
        contentLabel.font = .systemFont(ofSize: 17, weight: .regular)
        contentLabel.textColor = .white
        contentLabel.numberOfLines = 0
    }
    
    func configure(title: String, content: String) {
        titleLabel.text = title
        
        // Line spacing için attributed text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.lineHeightMultiple = 1.3
        paragraphStyle.paragraphSpacing = 4
        
        let attributedText = NSMutableAttributedString(string: content)
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        contentLabel.attributedText = attributedText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Blur effect view'ı güncelle
        if let blurView = blurEffectContainer.subviews.first(where: { $0 is UIVisualEffectView }) {
            blurView.frame = blurEffectContainer.bounds
        }
    }
}

