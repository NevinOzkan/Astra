//
//  CompatibilityViewController.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class CompatibilityViewController: UIViewController {
    
    private let viewModel: CompatibilityViewModel
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userZodiacCollectionView: UICollectionView!
    @IBOutlet weak var partnerZodiacCollectionView: UICollectionView!
    @IBOutlet weak var comparisonViewContainer: UIView!
    @IBOutlet weak var detailsCardContainer: UIView!
    @IBOutlet weak var commentTitleLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    private var comparisonView: ZodiacComparisonView?
    private var detailsCardView: CompatibilityDetailsCardView?
    
    init(viewModel: CompatibilityViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil ?? "CompatibilityViewController", bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupZodiacSelections()
        setupComparisonView()
        setupDetailsCard()
        setupCommentSection()
        setupViewModel()
        updateUI()
    }
    
    private func setupBackground() {
        // Koyu mor / lacivert arka plan, yıldızlı veya soft gradient efekt
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
            UIColor(red: 0.08, green: 0.05, blue: 0.18, alpha: 1).cgColor, // Koyu mor
            UIColor(red: 0.12, green: 0.08, blue: 0.25, alpha: 1).cgColor, // Mor-lacivert
            UIColor(red: 0.06, green: 0.1, blue: 0.22, alpha: 1).cgColor  // Lacivert
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Yıldız efekti için (opsiyonel - gelecekte eklenebilir)
        // addStarEffect()
    }
    
    private func setupZodiacSelections() {
        // User Zodiac Selection (Left)
        userZodiacCollectionView.delegate = self
        userZodiacCollectionView.dataSource = self
        userZodiacCollectionView.tag = 0 // Tag 0 = User sign
        userZodiacCollectionView.backgroundColor = .clear
        userZodiacCollectionView.showsHorizontalScrollIndicator = false
        
        let zodiacNib = UINib(nibName: "ZodiacSelectionCell", bundle: nil)
        userZodiacCollectionView.register(zodiacNib, forCellWithReuseIdentifier: "ZodiacSelectionCell")
        
        if let flowLayout = userZodiacCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 12
            flowLayout.minimumInteritemSpacing = 12
            flowLayout.itemSize = CGSize(width: 70, height: 90)
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        // Partner Zodiac Selection (Right)
        partnerZodiacCollectionView.delegate = self
        partnerZodiacCollectionView.dataSource = self
        partnerZodiacCollectionView.tag = 1 // Tag 1 = Partner sign
        partnerZodiacCollectionView.backgroundColor = .clear
        partnerZodiacCollectionView.showsHorizontalScrollIndicator = false
        
        partnerZodiacCollectionView.register(zodiacNib, forCellWithReuseIdentifier: "ZodiacSelectionCell")
        
        if let flowLayout = partnerZodiacCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 12
            flowLayout.minimumInteritemSpacing = 12
            flowLayout.itemSize = CGSize(width: 70, height: 90)
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    private func setupComparisonView() {
        comparisonView = ZodiacComparisonView()
        guard let comparison = comparisonView else { return }
        comparison.translatesAutoresizingMaskIntoConstraints = false
        comparisonViewContainer.addSubview(comparison)
        NSLayoutConstraint.activate([
            comparison.leadingAnchor.constraint(equalTo: comparisonViewContainer.leadingAnchor),
            comparison.trailingAnchor.constraint(equalTo: comparisonViewContainer.trailingAnchor),
            comparison.topAnchor.constraint(equalTo: comparisonViewContainer.topAnchor),
            comparison.bottomAnchor.constraint(equalTo: comparisonViewContainer.bottomAnchor)
        ])
    }
    
    private func setupDetailsCard() {
        detailsCardView = CompatibilityDetailsCardView()
        guard let detailsCard = detailsCardView else { return }
        detailsCard.translatesAutoresizingMaskIntoConstraints = false
        detailsCardContainer.addSubview(detailsCard)
        NSLayoutConstraint.activate([
            detailsCard.leadingAnchor.constraint(equalTo: detailsCardContainer.leadingAnchor),
            detailsCard.trailingAnchor.constraint(equalTo: detailsCardContainer.trailingAnchor),
            detailsCard.topAnchor.constraint(equalTo: detailsCardContainer.topAnchor),
            detailsCard.bottomAnchor.constraint(equalTo: detailsCardContainer.bottomAnchor)
        ])
    }
    
    private func setupCommentSection() {
        commentTitleLabel?.text = "Genel Yorum"
        commentTitleLabel?.textColor = .white
        commentTitleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        commentTextLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        commentTextLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        commentTextLabel?.numberOfLines = 0
    }
    
    private func setupViewModel() {
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                // Error handling (isteğe bağlı)
                print("Error: \(errorMessage)")
            }
        }
        
        viewModel.load()
    }
    
    private func updateUI() {
        guard let compatibilityData = viewModel.compatibilityData else { return }
        
        let userSign = viewModel.currentUserSign
        let partnerSign = viewModel.currentPartnerSign
        let overallPercentage = viewModel.overallPercentage
        
        // Comparison view'ı güncelle
        comparisonView?.configure(
            leftSign: userSign,
            rightSign: partnerSign,
            overallPercentage: overallPercentage
        )
        
        // Details card'ı güncelle
        detailsCardView?.configure(
            love: compatibilityData.love,
            friendship: compatibilityData.friendship,
            work: compatibilityData.work
        )
        
        // Comment text'i güncelle
        commentTextLabel?.text = viewModel.generalComment
        
        // Collection view'ları güncelle
        userZodiacCollectionView.reloadData()
        partnerZodiacCollectionView.reloadData()
        
        // Seçili burçları scroll et
        scrollToSelectedSigns()
    }
    
    private func scrollToSelectedSigns() {
        let userSign = viewModel.currentUserSign
        let partnerSign = viewModel.currentPartnerSign
        
        if let userIndex = viewModel.allSigns.firstIndex(where: { $0.name == userSign.name }) {
            let indexPath = IndexPath(item: userIndex, section: 0)
            userZodiacCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        if let partnerIndex = viewModel.allSigns.firstIndex(where: { $0.name == partnerSign.name }) {
            let indexPath = IndexPath(item: partnerIndex, section: 0)
            partnerZodiacCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
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
        
        navigationItem.title = ""
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension CompatibilityViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allSigns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZodiacSelectionCell", for: indexPath) as! ZodiacSelectionCell
        
        let sign = viewModel.allSigns[indexPath.item]
        let isSelected: Bool
        
        if collectionView.tag == 0 {
            // User sign collection
            isSelected = sign.name == viewModel.currentUserSign.name
        } else {
            // Partner sign collection
            isSelected = sign.name == viewModel.currentPartnerSign.name
        }
        
        cell.configure(sign: sign, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSign = viewModel.allSigns[indexPath.item]
        
        if collectionView.tag == 0 {
            // User sign seçildi
            viewModel.selectUserSign(selectedSign)
        } else {
            // Partner sign seçildi
            viewModel.selectPartnerSign(selectedSign)
        }
        
        // Collection view'ları güncelle
        userZodiacCollectionView.reloadData()
        partnerZodiacCollectionView.reloadData()
    }
}


