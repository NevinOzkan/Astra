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
    
    @IBOutlet weak var zodiacSelectionCollectionView: UICollectionView!
    @IBOutlet weak var selectedSignTitleLabel: UILabel!
    @IBOutlet weak var selectedSignSubtitleLabel: UILabel!
    @IBOutlet weak var compatibilityCollectionView: UICollectionView!
    
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
        setupCollectionViews()
        setupViewModel()
        updateUI()
    }
    
    private func setupBackground() {
        // Uzay temalı gradient arka plan (Home ile aynı)
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
    
    private func setupCollectionViews() {
        // Zodiac Selection Collection View (Horizontal)
        zodiacSelectionCollectionView.delegate = self
        zodiacSelectionCollectionView.dataSource = self
        zodiacSelectionCollectionView.backgroundColor = .clear
        zodiacSelectionCollectionView.showsHorizontalScrollIndicator = false
        
        let zodiacNib = UINib(nibName: "ZodiacSelectionCell", bundle: nil)
        zodiacSelectionCollectionView.register(zodiacNib, forCellWithReuseIdentifier: "ZodiacSelectionCell")
        
        if let flowLayout = zodiacSelectionCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 12
            flowLayout.minimumInteritemSpacing = 12
            flowLayout.itemSize = CGSize(width: 80, height: 100)
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
        // Compatibility Collection View (Vertical)
        compatibilityCollectionView.delegate = self
        compatibilityCollectionView.dataSource = self
        compatibilityCollectionView.backgroundColor = .clear
        compatibilityCollectionView.showsVerticalScrollIndicator = true  // Scroll indicator göster
        
        let compatibilityNib = UINib(nibName: "CompatibilityCell", bundle: nil)
        compatibilityCollectionView.register(compatibilityNib, forCellWithReuseIdentifier: "CompatibilityCell")
        
        if let flowLayout = compatibilityCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.minimumLineSpacing = 24  // Kartlar arası spacing artırıldı
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.itemSize = CGSize(width: 343, height: 160)  // Kart yüksekliği artırıldı
            flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 40, right: 16)  // Üst-alt boşluk eklendi
            flowLayout.estimatedItemSize = CGSize(width: 343, height: 160)
        }
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
        let selectedSign = viewModel.currentSelectedSign
        selectedSignTitleLabel.text = "\(selectedSign.name) Burcu Uyumları"
        selectedSignSubtitleLabel.text = "Diğer burçlarla enerjisel uyum"
        
        zodiacSelectionCollectionView.reloadData()
        compatibilityCollectionView.reloadData()
        
        // Seçili burcu collection view'da göster
        if let index = viewModel.allSigns.firstIndex(where: { $0.name == selectedSign.name }) {
            let indexPath = IndexPath(item: index, section: 0)
            zodiacSelectionCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
    
    // MARK: - Zodiac Selection Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == zodiacSelectionCollectionView {
            return viewModel.allSigns.count
        } else {
            return viewModel.compatibilities.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == zodiacSelectionCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZodiacSelectionCell", for: indexPath) as! ZodiacSelectionCell
            
            let sign = viewModel.allSigns[indexPath.item]
            let isSelected = sign.name == viewModel.currentSelectedSign.name
            cell.configure(sign: sign, isSelected: isSelected)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompatibilityCell", for: indexPath) as! CompatibilityCell
            
            let compatibility = viewModel.compatibilities[indexPath.item]
            cell.configure(compatibility: compatibility)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == zodiacSelectionCollectionView {
            let selectedSign = viewModel.allSigns[indexPath.item]
            viewModel.selectSign(selectedSign)
            
            // Animasyon
            UIView.animate(withDuration: 0.2) {
                collectionView.reloadData()
            }
        }
    }
}

