//
//  AstroScoreView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class AstroScoreView: UIView {
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var blurContainerView: UIView!
    @IBOutlet weak var cardContainerView: UIView!
    
    private var gradientProgressView: GradientProgressView?
    
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
        let nib = UINib(nibName: "AstroScoreView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func setupUI() {
        // Glassmorphism efekti - daha şeffaf
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurContainerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true
        blurContainerView.insertSubview(blurEffectView, at: 0)
        
        // Daha şeffaf arka plan
        blurContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        
        // Kart container stil
        cardContainerView.backgroundColor = .clear
        cardContainerView.layer.cornerRadius = 20
        cardContainerView.clipsToBounds = false
        
        // Shadow efekti - daha yumuşak
        cardContainerView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.1).cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardContainerView.layer.shadowRadius = 8
        cardContainerView.layer.shadowOpacity = 1.0
        
        // Gradient progress view
        let progressView = GradientProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressContainerView.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: progressContainerView.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: progressContainerView.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 6)
        ])
        gradientProgressView = progressView
        
        // Progress container arka planını şeffaf yap
        progressContainerView.backgroundColor = .clear
    }
    
    func configure(emoji: String, title: String, score: Float, maxScore: Float = 10.0, gradientColors: [UIColor]) {
        emojiLabel?.text = emoji
        titleLabel?.text = title
        scoreLabel?.text = String(format: "%.1f", score)
        
        let progress = score / maxScore
        gradientProgressView?.progress = progress
        gradientProgressView?.gradientColors = gradientColors
        
        // Metin renkleri - daha belirgin
        emojiLabel?.textColor = .white
        emojiLabel?.font = .systemFont(ofSize: 22)
        
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        
        scoreLabel?.textColor = .white
        scoreLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Blur effect view'ı güncelle
        if let blurView = blurContainerView.subviews.first(where: { $0 is UIVisualEffectView }) {
            blurView.frame = blurContainerView.bounds
        }
    }
}

