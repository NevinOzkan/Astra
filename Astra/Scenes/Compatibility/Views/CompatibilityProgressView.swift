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
            // Progress değerini clamp et (0.0 - 1.0 arası)
            let clampedProgress = max(0.0, min(1.0, progress))
            
            // Layout güncellenmiş olmalı
            if bounds.width > 0 {
                updateProgress()
                // Animasyonlu progress update
                animateProgress(from: oldValue, to: clampedProgress)
            } else {
                // Bounds henüz hazır değilse, layoutSubviews'da güncellenecek
                setNeedsLayout()
            }
        }
    }
    
    private func animateProgress(from: Float, to: Float) {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.6
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        progressLayer?.add(animation, forKey: "progressAnimation")
        gradientLayer?.add(animation, forKey: "gradientAnimation")
    }
    
    var gradientColors: [UIColor] = [.systemPink, .systemPurple] {
        didSet {
            updateGradient()
        }
    }
    
    var valueText: String = "" {
        didSet {
            valueLabel?.text = valueText
            valueLabel?.isHidden = valueText.isEmpty
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
        clipsToBounds = true
        
        // Track layer (arka plan)
        let track = CAShapeLayer()
        track.fillColor = UIColor.white.withAlphaComponent(0.15).cgColor
        trackLayer = track
        layer.addSublayer(track)
        
        // Gradient layer - önce gradient'i ekle
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = gradientColors.map { $0.cgColor }
        gradientLayer = gradient
        layer.addSublayer(gradient)
        
        // Progress layer - mask olarak kullanılacak
        let progress = CAShapeLayer()
        progress.fillColor = UIColor.white.cgColor // Mask için beyaz
        progressLayer = progress
        gradient.mask = progress
        
        // Value label (artık kullanılmıyor ama tutuyoruz)
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .right
        label.isHidden = true
        addSubview(label)
        valueLabel = label
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Bounds hazır olduğunda path'leri güncelle
        if bounds.width > 0 {
            updatePaths()
        }
        
        // Value label'ı sağa hizala
        valueLabel?.frame = CGRect(x: bounds.width - 40, y: 0, width: 35, height: bounds.height)
    }
    
    private func updatePaths() {
        guard bounds.width > 0 && bounds.height > 0 else { return }
        
        let height: CGFloat = 4
        let cornerRadius: CGFloat = 2
        
        // Track path - value label yoksa tam genişlik
        let trackWidth = valueText.isEmpty ? bounds.width : bounds.width - 45
        let trackRect = CGRect(x: 0, y: (bounds.height - height) / 2, width: trackWidth, height: height)
        let trackPath = UIBezierPath(roundedRect: trackRect, cornerRadius: cornerRadius)
        trackLayer?.path = trackPath.cgPath
        
        // Progress genişliği
        let progressWidth = max(0, min(trackWidth, trackWidth * CGFloat(progress)))
        
        // Progress path - progress genişliğine göre
        let progressRect = CGRect(x: 0, y: (bounds.height - height) / 2, width: progressWidth, height: height)
        let progressPath = UIBezierPath(roundedRect: progressRect, cornerRadius: cornerRadius)
        progressLayer?.path = progressPath.cgPath
        progressLayer?.fillColor = UIColor.white.cgColor // Mask için beyaz
        
        // Gradient layer frame - progress genişliğine göre (clipsToBounds ile kesilecek)
        let gradientFrame = CGRect(x: 0, y: (bounds.height - height) / 2, width: progressWidth, height: height)
        gradientLayer?.frame = gradientFrame
        gradientLayer?.cornerRadius = cornerRadius
        
        // Gradient layer'ın mask'ını progress layer olarak ayarla
        gradientLayer?.mask = progressLayer
    }
    
    private func updateProgress() {
        updatePaths()
    }
    
    private func updateGradient() {
        gradientLayer?.colors = gradientColors.map { $0.cgColor }
    }
}

