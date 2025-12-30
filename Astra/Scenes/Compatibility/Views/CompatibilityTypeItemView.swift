//
//  CompatibilityTypeItemView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class CompatibilityTypeItemView: UIView {
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var blurContainerView: UIView!
    @IBOutlet weak var cardContainerView: UIView!
    
    private var blurEffectView: UIVisualEffectView?
    private var progressView: CompatibilityProgressView?
    
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
        let nib = UINib(nibName: "CompatibilityTypeItemView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        // Arka plan tamamen şeffaf - ekranın kendi arka planı görünsün
        blurContainerView.backgroundColor = .clear
        
        // Kart container stil
        cardContainerView.backgroundColor = .clear
        cardContainerView.layer.cornerRadius = 16
        cardContainerView.clipsToBounds = true
        
        // Border kaldırıldı - beyaz kenar görünmesin
        cardContainerView.layer.borderWidth = 0
        
        // Shadow efekti kaldırıldı
        cardContainerView.layer.shadowOpacity = 0
        
        // Metin stilleri
        iconLabel?.textColor = .white
        iconLabel?.font = .systemFont(ofSize: 24)
        
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        
        percentageLabel?.textColor = .white
        percentageLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        percentageLabel?.textAlignment = .right
        
        // Progress view
        let progress = CompatibilityProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.valueText = ""
        progressContainerView.addSubview(progress)
        NSLayoutConstraint.activate([
            progress.leadingAnchor.constraint(equalTo: progressContainerView.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: progressContainerView.trailingAnchor),
            progress.topAnchor.constraint(equalTo: progressContainerView.topAnchor),
            progress.bottomAnchor.constraint(equalTo: progressContainerView.bottomAnchor)
        ])
        progressView = progress
    }
    
    func configure(type: CompatibilityType, percentage: Int) {
        iconLabel?.text = type.icon
        titleLabel?.text = type.title
        percentageLabel?.text = "%\(percentage)"
        
        progressView?.progress = Float(percentage) / 100.0
        
        // Her tür için farklı renk
        switch type {
        case .love:
            progressView?.gradientColors = [
                UIColor(red: 1.0, green: 0.4, blue: 0.6, alpha: 1), // Pembe
                UIColor(red: 0.8, green: 0.3, blue: 0.9, alpha: 1)  // Mor
            ]
        case .friendship:
            progressView?.gradientColors = [
                UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1), // Mavi
                UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1)  // Açık mavi
            ]
        case .work:
            progressView?.gradientColors = [
                UIColor(red: 0.2, green: 0.8, blue: 0.5, alpha: 1), // Yeşil
                UIColor(red: 0.4, green: 0.9, blue: 0.6, alpha: 1)  // Açık yeşil
            ]
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Border corner radius'ı güncelle
        cardContainerView.layer.cornerRadius = 16
    }
}

