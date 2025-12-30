//
//  CompatibilityTypeCardView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class CompatibilityTypeCardView: UIView {
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rowsStackView: UIStackView!
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
        let nib = UINib(nibName: "CompatibilityTypeCardView", bundle: bundle)
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
        
        blurContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        // Kart container stil
        cardContainerView.backgroundColor = .clear
        cardContainerView.layer.cornerRadius = 24
        cardContainerView.clipsToBounds = false
        
        // Shadow efekti
        cardContainerView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.2).cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 6)
        cardContainerView.layer.shadowRadius = 16
        cardContainerView.layer.shadowOpacity = 1.0
        
        // Stack view
        rowsStackView.axis = .vertical
        rowsStackView.alignment = .fill
        rowsStackView.distribution = .fill
        rowsStackView.spacing = 12
        
        // Metin stilleri
        iconLabel?.textColor = .white
        iconLabel?.font = .systemFont(ofSize: 28)
        
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    func configure(type: CompatibilityType, compatibilities: [Compatibility]) {
        iconLabel?.text = type.icon
        titleLabel?.text = type.title
        
        // Mevcut row'ları temizle
        rowsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Her burç için row ekle
        for compatibility in compatibilities {
            guard let sign = ZodiacSign.allSigns.first(where: { $0.name == compatibility.sign }) else { continue }
            
            let rowView = CompatibilityRowView()
            rowView.translatesAutoresizingMaskIntoConstraints = false
            
            let percentage: Int
            let gradientColors: [UIColor]
            
            switch type {
            case .love:
                percentage = compatibility.love
                gradientColors = [UIColor.systemPink, UIColor.systemPurple]
            case .friendship:
                percentage = compatibility.friendship
                gradientColors = [UIColor.systemBlue, UIColor.systemCyan]
            case .work:
                percentage = compatibility.work
                gradientColors = [UIColor(red: 0.3, green: 0.3, blue: 0.5, alpha: 1), UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1)]
            }
            
            rowView.configure(sign: sign, percentage: percentage, gradientColors: gradientColors)
            rowsStackView.addArrangedSubview(rowView)
            
            // Row view height constraint
            rowView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Blur view'ı güncelle
        if let blurView = blurEffectView {
            blurView.frame = blurContainerView.bounds
        }
    }
}

enum CompatibilityType {
    case love
    case friendship
    case work
    
    var icon: String {
        switch self {
        case .love: return "❤️"
        case .friendship: return "🤝"
        case .work: return "💼"
        }
    }
    
    var title: String {
        switch self {
        case .love: return "Aşk Uyumu"
        case .friendship: return "Arkadaşlık Uyumu"
        case .work: return "İş Uyumu"
        }
    }
}

