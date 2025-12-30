//
//  SettingsViewController.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Settings sections
    private let sections: [String] = [
        "Profil",
        "Bildirimler",
        "Dil",
        "Hakkında"
    ]
    
    // Settings rows for each section
    private let settingsData: [String: [String]] = [
        "Profil": ["Burcumu Değiştir", "Doğum Tarihi / Saati", "Yükselen Bilgisi"],
        "Bildirimler": ["Günlük Bildirim"],
        "Dil": ["Dil Seçimi"],
        "Hakkında": ["Uygulama Versiyonu"]
    ]
    
    // Switch states
    private var isNotificationEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "isNotificationEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "isNotificationEnabled") }
    }
    
    // Seçili burç
    private var selectedZodiacIndex: Int {
        get {
            let saved = UserDefaults.standard.integer(forKey: "selectedZodiacIndex")
            // Eğer kayıtlı değer yoksa varsayılan olarak Koç (index 0) döndür
            let count = 12 // zodiacSigns.count yerine sabit değer
            return saved >= 0 && saved < count ? saved : 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedZodiacIndex")
        }
    }
    
    // Picker açık/kapalı durumu
    private var isZodiacPickerExpanded: Bool = false
    
    // Picker kapanma timer'ı
    private var pickerCloseTimer: Timer?
    
    private let zodiacSigns: [String] = [
        "Koç",
        "Boğa",
        "İkizler",
        "Yengeç",
        "Aslan",
        "Başak",
        "Terazi",
        "Akrep",
        "Yay",
        "Oğlak",
        "Kova",
        "Balık"
    ]
    
    private let zodiacSymbols: [String] = [
        "♈", "♉", "♊", "♋", "♌", "♍",
        "♎", "♏", "♐", "♑", "♒", "♓"
    ]
    
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil ?? "SettingsViewController", bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupTableView()
        setupAppearance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Timer'ı temizle
        pickerCloseTimer?.invalidate()
        pickerCloseTimer = nil
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // iOS Settings benzeri görünüm için value1 style kullan
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PickerCell")
        
        // Table view arka planı şeffaf (gradient görünsün)
        tableView.backgroundColor = .clear
        
        // Profil bölümünün görünmesi için content inset ekle
        tableView.contentInsetAdjustmentBehavior = .automatic
    }
    
    private func setupBackground() {
        // Uzay temalı gradient arka plan (Home ile aynı)
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
    
    private func setupAppearance() {
        // Navigation bar title'ı kaldır
        navigationItem.title = ""
        navigationController?.navigationBar.isHidden = true
        
        // Table view arka planını şeffaf yap (gradient görünsün)
        tableView.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Gradient layer'ı güncelle
        if let gradientLayer = view.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = view.bounds
        }
    }
    
    @objc private func notificationSwitchChanged(_ sender: UISwitch) {
        isNotificationEnabled = sender.isOn
        // Bildirim ayarlarını güncelle
        print("Bildirimler: \(sender.isOn ? "Açık" : "Kapalı")")
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return zodiacSigns.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Seçimi kaydet
        selectedZodiacIndex = row
        
        print("✅ Picker'da seçim yapıldı: \(zodiacSymbols[row]) \(zodiacSigns[row])")
        
        // Önceki timer'ı iptal et
        pickerCloseTimer?.invalidate()
        
        // "Burcumu Değiştir" satırını hemen güncelle
        updateZodiacSelectionCell()
        
        // Picker'ı otomatik kapat (kullanıcının seçimini görmesi için kısa bir gecikme)
        pickerCloseTimer = Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { [weak self] _ in
            print("⏰ Timer tetiklendi, picker kapatılıyor...")
            self?.closeZodiacPicker()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let existingLabel = view as? UILabel {
            label = existingLabel
        } else {
            label = UILabel()
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 20)
        }
        
        label.text = "\(zodiacSymbols[row]) \(zodiacSigns[row])"
        label.textColor = .white  // Dark background için beyaz text
        
        return label
    }
    
    private func updateZodiacSelectionCell() {
        // "Burcumu Değiştir" satırını güncelle
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
            let selectedZodiac = zodiacSigns[selectedZodiacIndex]
            let selectedSymbol = zodiacSymbols[selectedZodiacIndex]
            cell.detailTextLabel?.text = "\(selectedSymbol) \(selectedZodiac)"
            print("📝 Cell güncellendi: \(selectedSymbol) \(selectedZodiac)")
        } else {
            // Cell henüz görünmüyorsa reload et
            print("🔄 Cell reload ediliyor...")
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private func closeZodiacPicker() {
        guard isZodiacPickerExpanded else {
            print("⚠️ Picker zaten kapalı")
            return
        }
        
        print("🔒 Picker kapatılıyor...")
        
        pickerCloseTimer?.invalidate()
        pickerCloseTimer = nil
        
        isZodiacPickerExpanded = false
        
        // Animasyonlu olarak picker satırını kaldır
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
        tableView.endUpdates()
        
        // "Burcumu Değiştir" satırını güncelle
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateZodiacSelectionCell()
            print("✅ Picker kapatıldı ve cell güncellendi")
        }
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sections[section]
        let baseCount = settingsData[sectionTitle]?.count ?? 0
        
        // Profil section'ında picker açıksa bir satır daha ekle
        if sectionTitle == "Profil" && isZodiacPickerExpanded {
            // Picker satırı "Burcumu Değiştir" satırından sonra eklenir
            return baseCount + 1
        }
        
        return baseCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionTitle = sections[indexPath.section]
        
        // Profil section'ında picker satırı kontrolü
        // Picker "Burcumu Değiştir" satırından sonra (row 1) eklenir
        if sectionTitle == "Profil" && isZodiacPickerExpanded && indexPath.row == 1 {
            // Picker cell'i
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerCell", for: indexPath)
            
            // Mevcut picker'ı kontrol et, yoksa oluştur
            var pickerView: UIPickerView? = cell.contentView.subviews.first(where: { $0 is UIPickerView }) as? UIPickerView
            
            if pickerView == nil {
                pickerView = UIPickerView()
                pickerView!.delegate = self
                pickerView!.dataSource = self
                pickerView!.translatesAutoresizingMaskIntoConstraints = false
                
                cell.contentView.addSubview(pickerView!)
                NSLayoutConstraint.activate([
                    pickerView!.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    pickerView!.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                    pickerView!.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                    pickerView!.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                    pickerView!.heightAnchor.constraint(equalToConstant: 185) // UIPickerView yüksekliği (standart 216'den %14 azaltıldı)
                ])
            } else {
                // Mevcut picker'ın delegate'lerini güncelle (cell yeniden kullanıldığında kaybolabilir)
                pickerView!.delegate = self
                pickerView!.dataSource = self
            }
            
            // Seçili satırı güncelle
            pickerView!.selectRow(selectedZodiacIndex, inComponent: 0, animated: false)
            
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            
            return cell
        }
        
        // Profil section'ında picker açıksa, satır index'lerini ayarla
        let rowIndex: Int
        if sectionTitle == "Profil" && isZodiacPickerExpanded {
            // Picker açıksa: row 0 = "Burcumu Değiştir", row 1 = picker, row 2+ = diğer satırlar
            rowIndex = indexPath.row == 0 ? 0 : indexPath.row - 1
        } else {
            rowIndex = indexPath.row
        }
        
        // Burcumu Değiştir için value1 style kullan (iOS Settings benzeri)
        let isZodiacRow = sectionTitle == "Profil" && settingsData[sectionTitle]?[rowIndex] == "Burcumu Değiştir"
        
        // Normal settings cell'i
        let cell: UITableViewCell
        if isZodiacRow {
            // Burç Seçimi için value1 style ile yeni cell oluştur
            cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        }
        
        // Eski içeriği temizle
        cell.textLabel?.text = nil
        cell.detailTextLabel?.text = nil
        cell.accessoryView = nil
        cell.accessoryType = .none
        
        if let rowTitle = settingsData[sectionTitle]?[rowIndex] {
            cell.textLabel?.font = .systemFont(ofSize: 17)
            cell.textLabel?.textColor = .white  // Dark background için beyaz text
            
            // Bildirimler için switch ekle
            if rowTitle == "Günlük Bildirim" {
                cell.textLabel?.text = rowTitle
                let switchControl = UISwitch()
                switchControl.isOn = isNotificationEnabled
                switchControl.addTarget(self, action: #selector(notificationSwitchChanged(_:)), for: .valueChanged)
                cell.accessoryView = switchControl
                cell.selectionStyle = .none
            } else if rowTitle == "Burcumu Değiştir" {
                // Burç seçimi için seçili burcu detailTextLabel'da göster (işaret + isim)
                cell.textLabel?.text = rowTitle
                let selectedZodiac = zodiacSigns[selectedZodiacIndex]
                let selectedSymbol = zodiacSymbols[selectedZodiacIndex]
                cell.detailTextLabel?.text = "\(selectedSymbol) \(selectedZodiac)"
                cell.detailTextLabel?.font = .systemFont(ofSize: 17)
                cell.detailTextLabel?.textColor = UIColor.white.withAlphaComponent(0.7)  // Beyaz ama biraz soluk
                cell.selectionStyle = .default
            } else if rowTitle == "Doğum Tarihi / Saati" {
                cell.textLabel?.text = rowTitle
                cell.detailTextLabel?.text = "Ayarla"
                cell.detailTextLabel?.font = .systemFont(ofSize: 17)
                cell.detailTextLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            } else if rowTitle == "Yükselen Bilgisi" {
                cell.textLabel?.text = rowTitle
                cell.detailTextLabel?.text = "Ayarla"
                cell.detailTextLabel?.font = .systemFont(ofSize: 17)
                cell.detailTextLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            } else {
                // Diğer hücreler için disclosure indicator
                cell.textLabel?.text = rowTitle
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            }
        }
        
        // Hücre görünümünü iyileştir - glassmorphism efekti için şeffaf arka plan
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // İlk bölüm için daha fazla boşluk
        if section == 0 {
            return 50
        }
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = sections[section]
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.7)  // Dark background için beyaz ama soluk
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sectionTitle = sections[indexPath.section]
        
        // Profil section'ında picker satırına tıklanmışsa hiçbir şey yapma
        if sectionTitle == "Profil" && isZodiacPickerExpanded && indexPath.row == 1 {
            return
        }
        
        // Profil section'ında picker açıksa, satır index'lerini ayarla
        let rowIndex: Int
        if sectionTitle == "Profil" && isZodiacPickerExpanded {
            // Picker açıksa: row 0 = "Burcumu Değiştir", row 1 = picker, row 2+ = diğer satırlar
            rowIndex = indexPath.row == 0 ? 0 : indexPath.row - 1
        } else {
            rowIndex = indexPath.row
        }
        
        if let rowTitle = settingsData[sectionTitle]?[rowIndex] {
            // Switch olan hücreler için seçim yapma
            if rowTitle == "Günlük Bildirim" {
                return
            }
            
            // Burç seçimi için picker'ı toggle et
            if rowTitle == "Burcumu Değiştir" {
                // Picker açılıyorsa timer'ı temizle
                if !isZodiacPickerExpanded {
                    pickerCloseTimer?.invalidate()
                    pickerCloseTimer = nil
                }
                
                isZodiacPickerExpanded.toggle()
                
                // Animasyonlu olarak satır ekle/kaldır
                tableView.beginUpdates()
                if isZodiacPickerExpanded {
                    tableView.insertRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .fade)
                } else {
                    tableView.deleteRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .fade)
                }
                tableView.endUpdates()
                
                // "Burcumu Değiştir" satırını güncelle
                tableView.reloadRows(at: [IndexPath(row: 0, section: indexPath.section)], with: .none)
                return
            }
            
            // Doğum Tarihi / Saati ve Yükselen Bilgisi için placeholder
            if rowTitle == "Doğum Tarihi / Saati" {
                print("Doğum Tarihi / Saati seçildi - Gelecekte implement edilecek")
                // TODO: Date picker veya navigation push eklenebilir
            } else if rowTitle == "Yükselen Bilgisi" {
                print("Yükselen Bilgisi seçildi - Gelecekte implement edilecek")
                // TODO: Yükselen burç seçimi eklenebilir
            } else {
                // Diğer hücreler için placeholder
                print("Seçildi: \(rowTitle)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionTitle = sections[indexPath.section]
        
        // Picker satırı için özel yükseklik
        if sectionTitle == "Profil" && isZodiacPickerExpanded && indexPath.row == 1 {
            return 185 // UIPickerView yüksekliği (standart 216'den %14 azaltıldı)
        }
        
        return UITableView.automaticDimension
    }
}

