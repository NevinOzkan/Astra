//
//  PremiumPaywallViewController.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class PremiumPaywallViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var purchaseButton: UIButton!
    
    var onPurchaseComplete: (() -> Void)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil ?? "PremiumPaywallViewController", bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupUI()
    }
    
    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1).cgColor,
            UIColor(red: 0.1, green: 0.05, blue: 0.2, alpha: 1).cgColor,
            UIColor(red: 0.05, green: 0.1, blue: 0.25, alpha: 1).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        
        titleLabel?.text = "Premium'a Geç"
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel?.textAlignment = .center
        
        subtitleLabel?.text = "Sınırsız meditasyon erişimi ve daha fazlası"
        subtitleLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
        subtitleLabel?.font = .systemFont(ofSize: 16)
        subtitleLabel?.textAlignment = .center
        
        closeButton?.setTitle("Kapat", for: .normal)
        closeButton?.setTitleColor(.white, for: .normal)
        closeButton?.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        purchaseButton?.setTitle("Premium Satın Al", for: .normal)
        purchaseButton?.backgroundColor = UIColor.systemBlue
        purchaseButton?.layer.cornerRadius = 12
        purchaseButton?.setTitleColor(.white, for: .normal)
        purchaseButton?.addTarget(self, action: #selector(purchaseTapped), for: .touchUpInside)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc private func purchaseTapped() {
        // Premium satın alma işlemi (placeholder)
        // Şimdilik sadece premium'u aktif ediyoruz
        PremiumManager.shared.setPremium(true)
        
        // Callback'i çağır
        onPurchaseComplete?()
        
        let alert = UIAlertController(title: "Premium Aktif", message: "Premium özellikler aktif edildi.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
}

