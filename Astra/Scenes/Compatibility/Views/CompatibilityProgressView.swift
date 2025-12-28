//
//  CompatibilityProgressView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class CompatibilityProgressView: UIView {
    
    private var trackLayer: CAShapeLayer?
    private var progressLayer: CAShapeLayer?
    private var gradientLayer: CAGradientLayer?
    private var valueLabel: UILabel?
    
    var progress: Float = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    var gradientColors: [UIColor] = [.systemPink, .systemPurple] {
        didSet {
            updateGradient()
        }
    }
    
    var valueText: String = "" {
        didSet {
            valueLabel?.text = valueText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        backgroundColor = .clear
        
        // Track layer (arka plan)
        let track = CAShapeLayer()
        track.fillColor = UIColor.white.withAlphaComponent(0.2).cgColor
        trackLayer = track
        layer.addSublayer(track)
        
        // Progress layer
        let progress = CAShapeLayer()
        progress.fillColor = UIColor.clear.cgColor
        progressLayer = progress
        
        // Gradient layer
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = gradientColors.map { $0.cgColor }
        gradient.mask = progress
        gradientLayer = gradient
        layer.addSublayer(gradient)
        
        // Value label
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .right
        addSubview(label)
        valueLabel = label
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePaths()
        
        // Value label'ı sağa hizala
        valueLabel?.frame = CGRect(x: bounds.width - 40, y: 0, width: 35, height: bounds.height)
    }
    
    private func updatePaths() {
        let height: CGFloat = 8
        let cornerRadius: CGFloat = 4
        
        // Track path
        let trackRect = CGRect(x: 0, y: (bounds.height - height) / 2, width: bounds.width - 45, height: height)
        let trackPath = UIBezierPath(roundedRect: trackRect, cornerRadius: cornerRadius)
        trackLayer?.path = trackPath.cgPath
        
        // Progress path
        let progressWidth = (bounds.width - 45) * CGFloat(progress)
        let progressRect = CGRect(x: 0, y: (bounds.height - height) / 2, width: progressWidth, height: height)
        let progressPath = UIBezierPath(roundedRect: progressRect, cornerRadius: cornerRadius)
        progressLayer?.path = progressPath.cgPath
        
        // Gradient frame
        gradientLayer?.frame = CGRect(x: 0, y: (bounds.height - height) / 2, width: progressWidth, height: height)
        gradientLayer?.cornerRadius = cornerRadius
    }
    
    private func updateProgress() {
        updatePaths()
    }
    
    private func updateGradient() {
        gradientLayer?.colors = gradientColors.map { $0.cgColor }
    }
}

