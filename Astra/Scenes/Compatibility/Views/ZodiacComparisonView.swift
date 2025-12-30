//
//  ZodiacComparisonView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class ZodiacComparisonView: UIView {
    
    @IBOutlet weak var leftZodiacIconView: UIView!
    @IBOutlet weak var leftZodiacSymbolLabel: UILabel!
    @IBOutlet weak var leftZodiacNameLabel: UILabel!
    @IBOutlet weak var rightZodiacIconView: UIView!
    @IBOutlet weak var rightZodiacSymbolLabel: UILabel!
    @IBOutlet weak var rightZodiacNameLabel: UILabel!
    @IBOutlet weak var percentageCircleView: UIView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var percentageSubtitleLabel: UILabel!
    
    private var leftGradientLayer: CAGradientLayer?
    private var rightGradientLayer: CAGradientLayer?
    private var circleProgressLayer: CAShapeLayer?
    private var circleTrackLayer: CAShapeLayer?
    
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
        let nib = UINib(nibName: "ZodiacComparisonView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // Left zodiac icon
        setupZodiacIcon(leftZodiacIconView, gradientLayer: &leftGradientLayer)
        
        // Right zodiac icon
        setupZodiacIcon(rightZodiacIconView, gradientLayer: &rightGradientLayer)
        
        // Text styles
        leftZodiacSymbolLabel?.textColor = .white
        leftZodiacSymbolLabel?.font = .systemFont(ofSize: 32)
        leftZodiacSymbolLabel?.textAlignment = .center
        
        leftZodiacNameLabel?.textColor = .white
        leftZodiacNameLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        leftZodiacNameLabel?.textAlignment = .center
        
        rightZodiacSymbolLabel?.textColor = .white
        rightZodiacSymbolLabel?.font = .systemFont(ofSize: 32)
        rightZodiacSymbolLabel?.textAlignment = .center
        
        rightZodiacNameLabel?.textColor = .white
        rightZodiacNameLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        rightZodiacNameLabel?.textAlignment = .center
        
        // Percentage circle
        setupPercentageCircle()
        
        percentageLabel?.textColor = .white
        percentageLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        percentageLabel?.textAlignment = .center
        percentageLabel?.adjustsFontSizeToFitWidth = true
        percentageLabel?.minimumScaleFactor = 0.5
        
        percentageSubtitleLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
        percentageSubtitleLabel?.font = .systemFont(ofSize: 11, weight: .medium)
        percentageSubtitleLabel?.textAlignment = .center
    }
    
    private func setupZodiacIcon(_ iconView: UIView, gradientLayer: inout CAGradientLayer?) {
        iconView.backgroundColor = .clear
        iconView.clipsToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        gradient.colors = [
            UIColor(red: 0.5, green: 0.3, blue: 0.8, alpha: 1).cgColor,
            UIColor(red: 0.2, green: 0.4, blue: 0.9, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        iconView.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    private func setupPercentageCircle() {
        percentageCircleView.backgroundColor = .clear
        
        // Track layer (background circle)
        let trackLayer = CAShapeLayer()
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 6
        trackLayer.lineCap = .round
        percentageCircleView.layer.addSublayer(trackLayer)
        circleTrackLayer = trackLayer
        
        // Progress layer
        let progressLayer = CAShapeLayer()
        progressLayer.strokeColor = UIColor(red: 0.4, green: 0.9, blue: 0.6, alpha: 1).cgColor // Neon yeşil
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 6
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        percentageCircleView.layer.addSublayer(progressLayer)
        circleProgressLayer = progressLayer
    }
    
    func configure(leftSign: ZodiacSign, rightSign: ZodiacSign, overallPercentage: Int) {
        leftZodiacSymbolLabel?.text = leftSign.symbol
        leftZodiacNameLabel?.text = leftSign.name
        
        rightZodiacSymbolLabel?.text = rightSign.symbol
        rightZodiacNameLabel?.text = rightSign.name
        
        percentageLabel?.text = "%\(overallPercentage)"
        percentageSubtitleLabel?.text = "Uyum"
        
        // Animate circle progress
        let progress = Float(overallPercentage) / 100.0
        animateCircleProgress(to: progress)
    }
    
    private func animateCircleProgress(to progress: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = circleProgressLayer?.strokeEnd ?? 0
        animation.toValue = progress
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        circleProgressLayer?.strokeEnd = CGFloat(progress)
        circleProgressLayer?.add(animation, forKey: "progressAnimation")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Left icon circle
        let leftCornerRadius = leftZodiacIconView.bounds.width / 2
        leftZodiacIconView.layer.cornerRadius = leftCornerRadius
        leftGradientLayer?.frame = leftZodiacIconView.bounds
        leftGradientLayer?.cornerRadius = leftCornerRadius
        
        // Right icon circle
        let rightCornerRadius = rightZodiacIconView.bounds.width / 2
        rightZodiacIconView.layer.cornerRadius = rightCornerRadius
        rightGradientLayer?.frame = rightZodiacIconView.bounds
        rightGradientLayer?.cornerRadius = rightCornerRadius
        
        // Percentage circle path
        let center = CGPoint(x: percentageCircleView.bounds.midX, y: percentageCircleView.bounds.midY)
        let radius = min(percentageCircleView.bounds.width, percentageCircleView.bounds.height) / 2 - 3
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        
        circleTrackLayer?.path = circlePath.cgPath
        circleProgressLayer?.path = circlePath.cgPath
    }
}

