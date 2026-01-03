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
    @IBOutlet weak var meditationButton: UIButton!
    @IBOutlet weak var meditationLabel: UILabel!
    
    // Custom Views
    private var zodiacHeaderView: ZodiacHeaderView?
    private var dailyHoroscopeCardView: DailyHoroscopeCardView?
    private var loveScoreView: AstroScoreView?
    private var careerScoreView: AstroScoreView?
    private var healthScoreView: AstroScoreView?
    private var energyCardView: AstroModuleStackCardView?
    private var luckyHourCardView: AstroModuleStackCardView?
    
    
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
        setupMeditationButton()
    }
    
    private func setupMeditationButton() {
        guard let button = meditationButton else {
            print("⚠️ Meditasyon butonu outlet bağlantısı eksik!")
            return
        }
        
        // Meditasyon butonu stil - diğer kartlarla aynı boyutta (88x88)
        button.layer.cornerRadius = 44 // Yuvarlak buton için (88/2 = 44)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        button.setTitle("🧘", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 32)
        button.clipsToBounds = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(meditationButtonTapped), for: .touchUpInside)
        
        // Meditasyon label
        meditationLabel?.text = "Meditasyon"
        meditationLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        meditationLabel?.font = .systemFont(ofSize: 11, weight: .medium)
        meditationLabel?.textAlignment = .center
        
        print("✅ Meditasyon butonu hazırlandı")
    }
    
    @objc private func meditationButtonTapped() {
        print("🧘 Meditasyon butonuna tıklandı")
        let viewModel = MeditationViewModel()
        let meditationVC = MeditationViewController(viewModel: viewModel)
        
        if let navController = navigationController {
            navController.pushViewController(meditationVC, animated: true)
        } else {
            print("⚠️ Navigation controller bulunamadı!")
            // Fallback: Modal olarak göster
            let navController = UINavigationController(rootViewController: meditationVC)
            present(navController, animated: true)
        }
    }
    
    private func setupNumerologyButton() {
        // Numeroloji butonu oluştur
        let numerologyButton = UIButton(type: .system)
        numerologyButton.translatesAutoresizingMaskIntoConstraints = false
        numerologyButton.layer.cornerRadius = 44
        numerologyButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        numerologyButton.layer.borderWidth = 1.0
        numerologyButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        numerologyButton.setTitle("🔮", for: .normal)
        numerologyButton.titleLabel?.font = .systemFont(ofSize: 32)
        numerologyButton.clipsToBounds = true
        numerologyButton.isUserInteractionEnabled = true
        numerologyButton.addTarget(self, action: #selector(numerologyButtonTapped), for: .touchUpInside)
        
        // Numeroloji label
        let numerologyLabel = UILabel()
        numerologyLabel.text = "Numeroloji"
        numerologyLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        numerologyLabel.font = .systemFont(ofSize: 11, weight: .medium)
        numerologyLabel.textAlignment = .center
        numerologyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Container view
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(numerologyButton)
        containerView.addSubview(numerologyLabel)
        
        NSLayoutConstraint.activate([
            numerologyButton.widthAnchor.constraint(equalToConstant: 88),
            numerologyButton.heightAnchor.constraint(equalToConstant: 88),
            numerologyButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            numerologyButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            numerologyLabel.topAnchor.constraint(equalTo: numerologyButton.bottomAnchor, constant: 4),
            numerologyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            numerologyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            numerologyLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            containerView.widthAnchor.constraint(equalToConstant: 88),
            containerView.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        astroModulesStackView.addArrangedSubview(containerView)
    }
    
    @objc private func numerologyButtonTapped() {
        print("🔮 Numeroloji butonuna tıklandı")
        let viewModel = NumerologyViewModel()
        let numerologyVC = NumerologyViewController(viewModel: viewModel)
        
        if let navController = navigationController {
            navController.pushViewController(numerologyVC, animated: true)
        } else {
            print("⚠️ Navigation controller bulunamadı!")
            let navController = UINavigationController(rootViewController: numerologyVC)
            present(navController, animated: true)
        }
    }
    
    private func setupMoonStatusButton() {
        // Ayın durumu butonu oluştur
        let moonStatusButton = UIButton(type: .system)
        moonStatusButton.translatesAutoresizingMaskIntoConstraints = false
        moonStatusButton.layer.cornerRadius = 44
        moonStatusButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        moonStatusButton.layer.borderWidth = 1.0
        moonStatusButton.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        moonStatusButton.setTitle("🌕", for: .normal)
        moonStatusButton.titleLabel?.font = .systemFont(ofSize: 32)
        moonStatusButton.clipsToBounds = true
        moonStatusButton.isUserInteractionEnabled = true
        moonStatusButton.addTarget(self, action: #selector(moonStatusButtonTapped), for: .touchUpInside)
        
        // Ayın durumu label
        let moonStatusLabel = UILabel()
        moonStatusLabel.text = "Ayın durumu"
        moonStatusLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        moonStatusLabel.font = .systemFont(ofSize: 11, weight: .medium)
        moonStatusLabel.textAlignment = .center
        moonStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Container view
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(moonStatusButton)
        containerView.addSubview(moonStatusLabel)
        
        NSLayoutConstraint.activate([
            moonStatusButton.widthAnchor.constraint(equalToConstant: 88),
            moonStatusButton.heightAnchor.constraint(equalToConstant: 88),
            moonStatusButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            moonStatusButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            moonStatusLabel.topAnchor.constraint(equalTo: moonStatusButton.bottomAnchor, constant: 4),
            moonStatusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            moonStatusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            moonStatusLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            containerView.widthAnchor.constraint(equalToConstant: 88),
            containerView.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        astroModulesStackView.addArrangedSubview(containerView)
    }
    
    @objc private func moonStatusButtonTapped() {
        print("🌕 Ayın durumu butonuna tıklandı")
        let viewModel = MoonStatusViewModel()
        let moonStatusVC = MoonStatusViewController(viewModel: viewModel)
        
        if let navController = navigationController {
            navController.pushViewController(moonStatusVC, animated: true)
        } else {
            print("⚠️ Navigation controller bulunamadı!")
            let navController = UINavigationController(rootViewController: moonStatusVC)
            present(navController, animated: true)
        }
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
        energyCardView = AstroModuleStackCardView()
        luckyHourCardView = AstroModuleStackCardView()
        
        guard let energyCard = energyCardView,
              let luckyCard = luckyHourCardView else { return }
        
        // Meditasyon butonunu en başa ekle (zaten XIB'de stack içinde)
        // Buton zaten XIB'de stack içinde olduğu için burada eklemeye gerek yok
        
        // Numeroloji butonunu ekle
        setupNumerologyButton()
        
        // Ayın durumu butonunu ekle
        setupMoonStatusButton()
        
        // Diğer kartları ekle
        [energyCard, luckyCard].forEach { cardView in
            cardView.translatesAutoresizingMaskIntoConstraints = false
            astroModulesStackView.addArrangedSubview(cardView)
            cardView.widthAnchor.constraint(equalToConstant: 88).isActive = true
            cardView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        }
        
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
