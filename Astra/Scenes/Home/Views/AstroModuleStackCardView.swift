//
//  AstroModuleStackCardView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class AstroModuleStackCardView: UIView {
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var blurContainerView: UIView!
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet weak var contentStackView: UIStackView!
    
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
        let nib = UINib(nibName: "AstroModuleStackCardView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = .clear
        backgroundColor = .clear
        addSubview(view)
    }
    
    private func setupUI() {
        // EN DIŞ KART VIEW - Tamamen şeffaf (sadece shadow için)
        cardContainerView.backgroundColor = .clear
        // Shadow için clipsToBounds false, ama ana view'da true olacak
        cardContainerView.clipsToBounds = false
        cardContainerView.layer.masksToBounds = false
        
        // Shadow efekti - hafif (günlük yorum kartı ile uyumlu)
        cardContainerView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.15).cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardContainerView.layer.shadowRadius = 8
        cardContainerView.layer.shadowOpacity = 1.0
        
        // Blur container - Günlük yorum kartı ile aynı arka plan rengi
        // DailyHoroscopeCardView'daki blur container arka plan rengi: UIColor.white.withAlphaComponent(0.1)
        blurContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        // Glassmorphism efekti - blur view (günlük yorum kartı ile aynı)
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurContainerView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.clipsToBounds = true
        blurContainerView.insertSubview(blurView, at: 0)
        blurEffectView = blurView
        
        // Content stack view - dikey hizalama
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.distribution = .fill
        contentStackView.spacing = 8
        
        // Metin stilleri
        iconLabel?.textColor = .white
        iconLabel?.font = .systemFont(ofSize: 28)
        iconLabel?.textAlignment = .center
        
        titleLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        titleLabel?.font = .systemFont(ofSize: 11, weight: .medium)
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
        
        valueLabel?.textColor = .white
        valueLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        valueLabel?.textAlignment = .center
    }
    
    func configure(icon: String, title: String, value: String) {
        iconLabel?.text = icon
        titleLabel?.text = title
        valueLabel?.text = value
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // TAM DAİRE için corner radius = width / 2
        let cornerRadius = cardContainerView.bounds.width / 2
        cardContainerView.layer.cornerRadius = cornerRadius
        
        // Shadow path - tam daire (oval shadow)
        cardContainerView.layer.shadowPath = UIBezierPath(
            ovalIn: cardContainerView.bounds
        ).cgPath
        
        // Blur view'ı güncelle
        if let blurView = blurEffectView {
            blurView.frame = blurContainerView.bounds
            blurView.layer.cornerRadius = cornerRadius
        }
        
        // Ana view'ın clipsToBounds'u true - daire dışında hiçbir şey görünmesin
        clipsToBounds = true
        layer.masksToBounds = true
        backgroundColor = .clear
        
        // Card container'ın da arka planı şeffaf olsun (sadece blur container'da renk var)
        cardContainerView.backgroundColor = .clear
    }
}

