//
//  GradientProgressView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class GradientProgressView: UIView {
    
    private var trackLayer: CAShapeLayer?
    private var progressLayer: CAShapeLayer?
    private var gradientLayer: CAGradientLayer?
    
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
        
        // Track layer (arka plan) - daha görünür
        let track = CAShapeLayer()
        track.fillColor = UIColor.white.withAlphaComponent(0.25).cgColor
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePaths()
    }
    
    private func updatePaths() {
        let height: CGFloat = 6
        let cornerRadius: CGFloat = 3
        
        // Track path
        let trackRect = CGRect(x: 0, y: 0, width: bounds.width, height: height)
        let trackPath = UIBezierPath(roundedRect: trackRect, cornerRadius: cornerRadius)
        trackLayer?.path = trackPath.cgPath
        
        // Progress path
        let progressWidth = bounds.width * CGFloat(progress)
        let progressRect = CGRect(x: 0, y: 0, width: progressWidth, height: height)
        let progressPath = UIBezierPath(roundedRect: progressRect, cornerRadius: cornerRadius)
        progressLayer?.path = progressPath.cgPath
        
        // Gradient frame
        gradientLayer?.frame = CGRect(x: 0, y: 0, width: progressWidth, height: height)
        gradientLayer?.cornerRadius = cornerRadius
    }
    
    private func updateProgress() {
        updatePaths()
    }
    
    private func updateGradient() {
        gradientLayer?.colors = gradientColors.map { $0.cgColor }
    }
}

