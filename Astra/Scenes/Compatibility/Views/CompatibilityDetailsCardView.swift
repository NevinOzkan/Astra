//
//  CompatibilityDetailsCardView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class CompatibilityDetailsCardView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // Love Item
    @IBOutlet weak var loveIconLabel: UILabel!
    @IBOutlet weak var loveTitleLabel: UILabel!
    @IBOutlet weak var lovePercentageLabel: UILabel!
    @IBOutlet weak var loveProgressContainerView: UIView!
    
    // Friendship Item
    @IBOutlet weak var friendshipIconLabel: UILabel!
    @IBOutlet weak var friendshipTitleLabel: UILabel!
    @IBOutlet weak var friendshipPercentageLabel: UILabel!
    @IBOutlet weak var friendshipProgressContainerView: UIView!
    
    // Work Item
    @IBOutlet weak var workIconLabel: UILabel!
    @IBOutlet weak var workTitleLabel: UILabel!
    @IBOutlet weak var workPercentageLabel: UILabel!
    @IBOutlet weak var workProgressContainerView: UIView!
    
    @IBOutlet weak var blurContainerView: UIView!
    @IBOutlet weak var cardContainerView: UIView!
    
    private var loveProgressView: CompatibilityProgressView?
    private var friendshipProgressView: CompatibilityProgressView?
    private var workProgressView: CompatibilityProgressView?
    
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
        view.backgroundColor = .clear
        view.isOpaque = false
        addSubview(view)
    }
    
    private func setupUI() {
        backgroundColor = .clear
        isOpaque = false
        
        // Blur efekti kaldırıldı - tamamen şeffaf arka plan
        blurContainerView.backgroundColor = .clear
        blurContainerView.isOpaque = false
        
        // Kart container stil - tamamen şeffaf, sadece border ile ayrılacak
        cardContainerView.backgroundColor = .clear
        cardContainerView.isOpaque = false
        cardContainerView.layer.cornerRadius = 24
        cardContainerView.clipsToBounds = true
        
        // Border (çerçeve) - açık mor / soft beyaz
        cardContainerView.layer.borderWidth = 1.0
        cardContainerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        // Shadow efekti kaldırıldı - kartlar arka plandan kopuk durmasın
        cardContainerView.layer.shadowOpacity = 0
        
        // Başlık stili
        titleLabel?.text = "Uyum Detayları"
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        
        // Love Item Setup
        setupItem(
            iconLabel: loveIconLabel,
            titleLabel: loveTitleLabel,
            percentageLabel: lovePercentageLabel,
            progressContainer: loveProgressContainerView,
            progressView: &loveProgressView,
            type: .love
        )
        
        // Friendship Item Setup
        setupItem(
            iconLabel: friendshipIconLabel,
            titleLabel: friendshipTitleLabel,
            percentageLabel: friendshipPercentageLabel,
            progressContainer: friendshipProgressContainerView,
            progressView: &friendshipProgressView,
            type: .friendship
        )
        
        // Work Item Setup
        setupItem(
            iconLabel: workIconLabel,
            titleLabel: workTitleLabel,
            percentageLabel: workPercentageLabel,
            progressContainer: workProgressContainerView,
            progressView: &workProgressView,
            type: .work
        )
    }
    
    private func setupItem(
        iconLabel: UILabel?,
        titleLabel: UILabel?,
        percentageLabel: UILabel?,
        progressContainer: UIView,
        progressView: inout CompatibilityProgressView?,
        type: CompatibilityType
    ) {
        // Icon
        iconLabel?.text = type.icon
        iconLabel?.textColor = .white
        iconLabel?.font = .systemFont(ofSize: 24)
        iconLabel?.isHidden = false
        iconLabel?.alpha = 1.0
        
        // Title
        titleLabel?.text = type.title
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel?.textAlignment = .left
        
        // Percentage
        percentageLabel?.textColor = .white
        percentageLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        percentageLabel?.textAlignment = .right
        
        // Progress View
        progressContainer.clipsToBounds = true
        progressContainer.backgroundColor = .clear
        
        let progress = CompatibilityProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.valueText = ""
        progressContainer.addSubview(progress)
        
        NSLayoutConstraint.activate([
            progress.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor),
            progress.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progress.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor)
        ])
        
        // Gradient colors
        switch type {
        case .love:
            progress.gradientColors = [
                UIColor(red: 1.0, green: 0.4, blue: 0.6, alpha: 1), // Pembe
                UIColor(red: 0.8, green: 0.3, blue: 0.9, alpha: 1)  // Mor
            ]
        case .friendship:
            progress.gradientColors = [
                UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1), // Mavi
                UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1)  // Açık mavi
            ]
        case .work:
            progress.gradientColors = [
                UIColor(red: 0.2, green: 0.8, blue: 0.5, alpha: 1), // Yeşil
                UIColor(red: 0.4, green: 0.9, blue: 0.6, alpha: 1)  // Açık yeşil
            ]
        }
        
        progressView = progress
    }
    
    func configure(love: Int, friendship: Int, work: Int) {
        // Love
        lovePercentageLabel?.text = "%\(love)"
        
        // Friendship
        friendshipPercentageLabel?.text = "%\(friendship)"
        
        // Work
        workPercentageLabel?.text = "%\(work)"
        
        // Layout'u önce güncelle, sonra progress'i set et
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Layout'u güncelle
            self.loveProgressView?.setNeedsLayout()
            self.loveProgressView?.layoutIfNeeded()
            self.friendshipProgressView?.setNeedsLayout()
            self.friendshipProgressView?.layoutIfNeeded()
            self.workProgressView?.setNeedsLayout()
            self.workProgressView?.layoutIfNeeded()
            
            // Progress'i set et (layout hazır olduktan sonra)
            self.loveProgressView?.progress = Float(love) / 100.0
            self.friendshipProgressView?.progress = Float(friendship) / 100.0
            self.workProgressView?.progress = Float(work) / 100.0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Corner radius'ı güncelle
        cardContainerView.layer.cornerRadius = 24
    }
}
