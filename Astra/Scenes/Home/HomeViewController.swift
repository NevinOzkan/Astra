//
//  HomeViewController.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var dailyCardContainerView: UIView!
    @IBOutlet weak var astroScoresStackView: UIStackView!
    @IBOutlet weak var astroModulesStackView: UIStackView!
    
    // Custom Views
    private var zodiacHeaderView: ZodiacHeaderView?
    private var dailyHoroscopeCardView: DailyHoroscopeCardView?
    private var loveScoreView: AstroScoreView?
    private var careerScoreView: AstroScoreView?
    private var healthScoreView: AstroScoreView?
    private var moonStatusCardView: AstroModuleStackCardView?
    private var energyCardView: AstroModuleStackCardView?
    private var luckyHourCardView: AstroModuleStackCardView?
    
    // Astro Modules Data
    private let astroModules: [(icon: String, title: String, value: String)] = [
        ("🌙", "Ayın durumu", "Dolunay"),
        ("⚡", "Bugünün enerjisi", "Yüksek"),
        ("🕐", "Şanslı saat", "14:30")
    ]
    
    init(viewModel: HomeViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil ?? "HomeViewController", bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController UI yüklendi")
        
        setupBackground()
        setupCustomViews()
    }
    
    private func setupCustomViews() {
        // Zodiac Header View
        zodiacHeaderView = ZodiacHeaderView()
        guard let zodiacHeader = zodiacHeaderView else { return }
        zodiacHeader.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(zodiacHeader)
        NSLayoutConstraint.activate([
            zodiacHeader.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor),
            zodiacHeader.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor),
            zodiacHeader.topAnchor.constraint(equalTo: headerContainerView.topAnchor),
            zodiacHeader.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor)
        ])
        zodiacHeader.configure(zodiacName: "Balık", zodiacSymbol: "♓")
        
        // Astro Modules Stack Cards - Burç başlığının hemen altında
        moonStatusCardView = AstroModuleStackCardView()
        energyCardView = AstroModuleStackCardView()
        luckyHourCardView = AstroModuleStackCardView()
        
        guard let moonCard = moonStatusCardView,
              let energyCard = energyCardView,
              let luckyCard = luckyHourCardView else { return }
        
        [moonCard, energyCard, luckyCard].forEach { cardView in
            cardView.translatesAutoresizingMaskIntoConstraints = false
            astroModulesStackView.addArrangedSubview(cardView)
            cardView.widthAnchor.constraint(equalToConstant: 88).isActive = true
            cardView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        }
        
        moonCard.configure(icon: "🌙", title: "Ayın durumu", value: "Dolunay")
        energyCard.configure(icon: "⚡", title: "Bugünün enerjisi", value: "Yüksek")
        luckyCard.configure(icon: "🕐", title: "Şanslı saat", value: "14:30")
        
        // Daily Horoscope Card View
        dailyHoroscopeCardView = DailyHoroscopeCardView()
        guard let dailyCard = dailyHoroscopeCardView else { return }
        dailyCard.translatesAutoresizingMaskIntoConstraints = false
        dailyCardContainerView.addSubview(dailyCard)
        NSLayoutConstraint.activate([
            dailyCard.leadingAnchor.constraint(equalTo: dailyCardContainerView.leadingAnchor),
            dailyCard.trailingAnchor.constraint(equalTo: dailyCardContainerView.trailingAnchor),
            dailyCard.topAnchor.constraint(equalTo: dailyCardContainerView.topAnchor),
            dailyCard.bottomAnchor.constraint(equalTo: dailyCardContainerView.bottomAnchor)
        ])
        dailyCard.configure(
            title: "Bugün",
            content: "Bugün sizin için özel bir gün. Yıldızlar size rehberlik ediyor ve yeni fırsatlar kapınızı çalıyor. Cesaretinizi toplayın ve kalbinizin sesini dinleyin. Bugün aldığınız kararlar geleceğinizi şekillendirecek. Yıldızların enerjisi sizinle, bu günü en iyi şekilde değerlendirin."
        )
        
        // Astro Score Views
        loveScoreView = AstroScoreView()
        careerScoreView = AstroScoreView()
        healthScoreView = AstroScoreView()
        
        guard let loveScore = loveScoreView,
              let careerScore = careerScoreView,
              let healthScore = healthScoreView else { return }
        
        [loveScore, careerScore, healthScore].forEach { scoreView in
            scoreView.translatesAutoresizingMaskIntoConstraints = false
            astroScoresStackView.addArrangedSubview(scoreView)
            scoreView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
        
        loveScore.configure(
            emoji: "❤️",
            title: "Aşk",
            score: 7.8,
            gradientColors: [UIColor.systemPink, UIColor.systemPurple]
        )
        
        careerScore.configure(
            emoji: "💼",
            title: "Kariyer",
            score: 8.5,
            gradientColors: [UIColor.systemBlue, UIColor.systemCyan]
        )
        
        healthScore.configure(
            emoji: "🏥",
            title: "Sağlık",
            score: 6.0,
            gradientColors: [UIColor.systemGreen, UIColor.systemTeal]
        )
    }
    
    
    private func setupBackground() {
        // Uzay temalı gradient arka plan
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        // Deep navy → mor → lacivert gradient
        gradientLayer.colors = [
            UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1).cgColor, // Deep navy
            UIColor(red: 0.1, green: 0.05, blue: 0.2, alpha: 1).cgColor,  // Mor ton
            UIColor(red: 0.05, green: 0.1, blue: 0.25, alpha: 1).cgColor  // Lacivert
        ]
        
        // Dikey gradient
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Gradient layer'ı güncelle
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation bar title'ı kaldır
        navigationItem.title = ""
        navigationController?.navigationBar.isHidden = true
        
        // ViewModel binding'ini kur
        viewModel.onTitleUpdate = { [weak self] title in
            // Title güncellemesini kullanmıyoruz
        }
        
        // ViewModel'den data yükle
        viewModel.load()
    }
}
