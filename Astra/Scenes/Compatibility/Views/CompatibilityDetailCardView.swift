//
//  CompatibilityDetailCardView.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class CompatibilityDetailCardView: UIView {
    
    @IBOutlet weak var loveProgressContainerView: UIView!
    @IBOutlet weak var friendshipProgressContainerView: UIView!
    @IBOutlet weak var workProgressContainerView: UIView!
    @IBOutlet weak var lovePercentageLabel: UILabel!
    @IBOutlet weak var friendshipPercentageLabel: UILabel!
    @IBOutlet weak var workPercentageLabel: UILabel!
    @IBOutlet weak var blurContainerView: UIView!
    @IBOutlet weak var cardContainerView: UIView!
    
    private var blurEffectView: UIVisualEffectView?
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
        let nib = UINib(nibName: "CompatibilityDetailCardView", bundle: bundle)
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
        cardContainerView.layer.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 0.3).cgColor
        cardContainerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardContainerView.layer.shadowRadius = 20
        cardContainerView.layer.shadowOpacity = 1.0
        
        // Percentage labels
        lovePercentageLabel?.textColor = .white
        lovePercentageLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        lovePercentageLabel?.textAlignment = .right
        
        friendshipPercentageLabel?.textColor = .white
        friendshipPercentageLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        friendshipPercentageLabel?.textAlignment = .right
        
        workPercentageLabel?.textColor = .white
        workPercentageLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        workPercentageLabel?.textAlignment = .right
        
        // Progress view'ları programatik olarak ekle
        setupProgressViews()
    }
    
    private func setupProgressViews() {
        // Love Progress View
        let loveProgress = CompatibilityProgressView()
        loveProgress.translatesAutoresizingMaskIntoConstraints = false
        loveProgress.valueText = ""
        loveProgressContainerView.addSubview(loveProgress)
        NSLayoutConstraint.activate([
            loveProgress.leadingAnchor.constraint(equalTo: loveProgressContainerView.leadingAnchor),
            loveProgress.trailingAnchor.constraint(equalTo: loveProgressContainerView.trailingAnchor),
            loveProgress.topAnchor.constraint(equalTo: loveProgressContainerView.topAnchor),
            loveProgress.bottomAnchor.constraint(equalTo: loveProgressContainerView.bottomAnchor)
        ])
        loveProgressView = loveProgress
        
        // Friendship Progress View
        let friendshipProgress = CompatibilityProgressView()
        friendshipProgress.translatesAutoresizingMaskIntoConstraints = false
        friendshipProgress.valueText = ""
        friendshipProgressContainerView.addSubview(friendshipProgress)
        NSLayoutConstraint.activate([
            friendshipProgress.leadingAnchor.constraint(equalTo: friendshipProgressContainerView.leadingAnchor),
            friendshipProgress.trailingAnchor.constraint(equalTo: friendshipProgressContainerView.trailingAnchor),
            friendshipProgress.topAnchor.constraint(equalTo: friendshipProgressContainerView.topAnchor),
            friendshipProgress.bottomAnchor.constraint(equalTo: friendshipProgressContainerView.bottomAnchor)
        ])
        friendshipProgressView = friendshipProgress
        
        // Work Progress View
        let workProgress = CompatibilityProgressView()
        workProgress.translatesAutoresizingMaskIntoConstraints = false
        workProgress.valueText = ""
        workProgressContainerView.addSubview(workProgress)
        NSLayoutConstraint.activate([
            workProgress.leadingAnchor.constraint(equalTo: workProgressContainerView.leadingAnchor),
            workProgress.trailingAnchor.constraint(equalTo: workProgressContainerView.trailingAnchor),
            workProgress.topAnchor.constraint(equalTo: workProgressContainerView.topAnchor),
            workProgress.bottomAnchor.constraint(equalTo: workProgressContainerView.bottomAnchor)
        ])
        workProgressView = workProgress
    }
    
    func configure(love: Int, friendship: Int, work: Int) {
        // Love - neon yeşil / mor tonları
        loveProgressView?.progress = Float(love) / 100.0
        loveProgressView?.gradientColors = [
            UIColor(red: 0.4, green: 0.9, blue: 0.6, alpha: 1), // Neon yeşil
            UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 1)  // Mor
        ]
        lovePercentageLabel?.text = "%\(love)"
        
        // Friendship
        friendshipProgressView?.progress = Float(friendship) / 100.0
        friendshipProgressView?.gradientColors = [
            UIColor(red: 0.4, green: 0.9, blue: 0.6, alpha: 1),
            UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 1)
        ]
        friendshipPercentageLabel?.text = "%\(friendship)"
        
        // Work
        workProgressView?.progress = Float(work) / 100.0
        workProgressView?.gradientColors = [
            UIColor(red: 0.4, green: 0.9, blue: 0.6, alpha: 1),
            UIColor(red: 0.6, green: 0.4, blue: 0.9, alpha: 1)
        ]
        workPercentageLabel?.text = "%\(work)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Blur view'ı güncelle
        if let blurView = blurEffectView {
            blurView.frame = blurContainerView.bounds
        }
    }
}

