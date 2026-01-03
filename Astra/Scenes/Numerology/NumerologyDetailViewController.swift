//
//  NumerologyDetailViewController.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class NumerologyDetailViewController: UIViewController {
    
    private let card: NumerologyCard
    private let viewModel: NumerologyViewModel
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    init(card: NumerologyCard, viewModel: NumerologyViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.card = card
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil ?? "NumerologyDetailViewController", bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        navigationItem.title = card.title
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        titleLabel?.text = card.title
        titleLabel?.textColor = .white
        titleLabel?.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel?.textAlignment = .center
        
        // Tekâmül Sayısı için özel görünüm
        if card.id == "evolution" {
            if let evolutionNumbers = card.evolutionNumbers {
                if evolutionNumbers.isEmpty {
                    numberLabel?.text = "✓"
                    numberLabel?.textColor = .systemGreen
                    numberLabel?.font = .systemFont(ofSize: 100, weight: .bold)
                    numberLabel?.textAlignment = .center
                    
                    // Glow efekti
                    numberLabel?.layer.shadowColor = UIColor.systemGreen.cgColor
                    numberLabel?.layer.shadowOffset = .zero
                    numberLabel?.layer.shadowRadius = 15
                    numberLabel?.layer.shadowOpacity = 0.8
                } else {
                    // Tekâmül sayılarını grid olarak göster
                    numberLabel?.text = evolutionNumbers.map { String($0) }.joined(separator: "  ")
                    numberLabel?.textColor = .white
                    numberLabel?.font = .systemFont(ofSize: 56, weight: .bold)
                    numberLabel?.textAlignment = .center
                    numberLabel?.numberOfLines = 0
                    
                    // Glow efekti
                    numberLabel?.layer.shadowColor = UIColor.white.cgColor
                    numberLabel?.layer.shadowOffset = .zero
                    numberLabel?.layer.shadowRadius = 12
                    numberLabel?.layer.shadowOpacity = 0.6
                }
            } else {
                numberLabel?.text = "🔒"
                numberLabel?.font = .systemFont(ofSize: 80)
                numberLabel?.textAlignment = .center
            }
        } else if let number = card.number {
            numberLabel?.text = "\(number)"
            numberLabel?.textColor = .white
            numberLabel?.font = .systemFont(ofSize: 140, weight: .bold)
            numberLabel?.textAlignment = .center
            
            // Glow efekti
            numberLabel?.layer.shadowColor = UIColor.white.cgColor
            numberLabel?.layer.shadowOffset = .zero
            numberLabel?.layer.shadowRadius = 20
            numberLabel?.layer.shadowOpacity = 0.7
        } else {
            numberLabel?.text = "🔒"
            numberLabel?.font = .systemFont(ofSize: 80)
            numberLabel?.textAlignment = .center
        }
        
        // Günün Sayısı için premium kontrolü
        var descriptionText = card.description
        if card.id == "lifePath" {
            // Yaşam Yolu Sayısı için JSON'dan tam açıklama
            if let number = card.number {
                descriptionText = viewModel.getLifePathFullDescription(for: number)
            }
        } else if card.id == "destiny" {
            // Kader Sayısı için JSON'dan tam açıklama
            if let number = card.number {
                descriptionText = viewModel.getDestinyFullDescription(for: number)
            }
        } else if card.id == "soulUrge" {
            // Kalp Sayısı için JSON'dan tam açıklama
            if let number = card.number {
                descriptionText = viewModel.getSoulUrgeFullDescription(for: number)
            }
        } else if card.id == "personality" {
            // Kişilik Sayısı için JSON'dan tam açıklama
            if let number = card.number {
                descriptionText = viewModel.getPersonalityFullDescription(for: number)
            }
        } else if card.id == "daily" {
            if viewModel.isPremiumUser {
                // Premium kullanıcı: Tam açıklama
                if let number = card.number {
                    descriptionText = viewModel.getDailyNumberFullDescription(for: number)
                }
            } else {
                // Ücretsiz kullanıcı: Kısa açıklama
                if let number = card.number {
                    descriptionText = viewModel.getDailyNumberShortDescription(for: number)
                }
            }
        } else if card.id == "evolution" {
            // Tekâmül Sayısı için detaylı açıklama
            if let evolutionNumbers = card.evolutionNumbers, !evolutionNumbers.isEmpty {
                descriptionText = viewModel.getEvolutionDescription(for: evolutionNumbers)
            }
        }
        
        // Line spacing için attributed string
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        let attributedString = NSAttributedString(
            string: descriptionText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .medium),
                .foregroundColor: UIColor.white.withAlphaComponent(0.9),
                .paragraphStyle: paragraphStyle
            ]
        )
        descriptionLabel?.attributedText = attributedString
        descriptionLabel?.numberOfLines = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
}

