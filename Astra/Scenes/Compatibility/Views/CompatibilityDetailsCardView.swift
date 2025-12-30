//
//  CompatibilityDetailsCardView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class CompatibilityDetailsCardView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loveItemView: CompatibilityTypeItemView!
    @IBOutlet weak var friendshipItemView: CompatibilityTypeItemView!
    @IBOutlet weak var workItemView: CompatibilityTypeItemView!
    @IBOutlet weak var blurContainerView: UIView!
    @IBOutlet weak var cardContainerView: UIView!
    
    private var blurEffectView: UIVisualEffectView?
    
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
        let nib = UINib(nibName: "CompatibilityDetailsCardView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // Glassmorphism efekti
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurContainerView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = 24
        blurView.clipsToBounds = true
        blurContainerView.insertSubview(blurView, at: 0)
        blurEffectView = blurView
        
        // Arka plan - koyu mor ton
        blurContainerView.backgroundColor = UIColor(red: 0.12, green: 0.08, blue: 0.25, alpha: 0.8)
        
        // Kart container stil
        cardContainerView.backgroundColor = .clear
        cardContainerView.layer.cornerRadius = 24
        cardContainerView.clipsToBounds = false
        
        // Border (çizgi) ekle
        cardContainerView.layer.borderWidth = 1.0
        cardContainerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        // Shadow efekti
        cardContainerView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.2).cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardContainerView.layer.shadowRadius = 20
        cardContainerView.layer.shadowOpacity = 1.0
        
        // Başlık stili
        titleLabel?.text = "Uyum Detayları"
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    func configure(love: Int, friendship: Int, work: Int) {
        loveItemView.configure(type: .love, percentage: love)
        friendshipItemView.configure(type: .friendship, percentage: friendship)
        workItemView.configure(type: .work, percentage: work)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Blur view'ı güncelle
        if let blurView = blurEffectView {
            blurView.frame = blurContainerView.bounds
        }
    }
}

