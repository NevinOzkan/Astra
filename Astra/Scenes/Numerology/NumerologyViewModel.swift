//
//  NumerologyViewModel.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import Foundation

struct NumerologyCard {
    let id: String
    let title: String
    let number: Int?
    let description: String
    let isPremium: Bool
    let isLocked: Bool
}

class NumerologyViewModel {
    
    private let premiumManager = PremiumManager.shared
    
    // UserDefaults keys
    private let userNameKey = "numerologyUserName"
    private let userBirthDateKey = "selectedBirthDate" // Settings'ten alınacak
    
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var onNameRequired: (() -> Void)?
    var onBirthDateRequired: (() -> Void)?
    
    var isPremiumUser: Bool {
        return premiumManager.isPremiumUser
    }
    
    var userName: String? {
        get {
            return UserDefaults.standard.string(forKey: userNameKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userNameKey)
        }
    }
    
    var birthDate: Date? {
        get {
            if let timestamp = UserDefaults.standard.object(forKey: userBirthDateKey) as? Date {
                return timestamp
            }
            return nil // Doğum tarihi yoksa nil döndür
        }
        set {
            if let date = newValue {
                UserDefaults.standard.set(date, forKey: userBirthDateKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userBirthDateKey)
            }
        }
    }
    
    var hasBirthDate: Bool {
        return birthDate != nil
    }
    
    var availableCards: [NumerologyCard] {
        var cards: [NumerologyCard] = []
        
        // Debug: Premium durumunu kontrol et
        print("🔍 ViewModel - Premium durumu: \(isPremiumUser)")
        
        // 1. Yaşam Yolu Sayısı (ÜCRETSİZ) - Doğum tarihi gerekli
        if let birthDate = birthDate {
            let lifePathNumber = calculateLifePathNumber()
            cards.append(NumerologyCard(
                id: "lifePath",
                title: "Yaşam Yolu Sayın",
                number: lifePathNumber > 0 ? lifePathNumber : nil,
                description: lifePathNumber > 0 ? getLifePathDescription(for: lifePathNumber) : "Hesaplanıyor...",
                isPremium: false,
                isLocked: false
            ))
        } else {
            cards.append(NumerologyCard(
                id: "lifePath",
                title: "Yaşam Yolu Sayın",
                number: nil,
                description: "Doğum tarihi gerekli",
                isPremium: false,
                isLocked: false
            ))
        }
        
        // 2. Günün Sayısı (ÜCRETSİZ - KISITLI) - Her zaman hesaplanabilir
        let dailyNumber = calculateDailyNumber()
        if isPremiumUser {
            // Premium kullanıcı: Tam açıklama
            cards.append(NumerologyCard(
                id: "daily",
                title: "Günün Sayısı",
                number: dailyNumber,
                description: getDailyNumberFullDescription(for: dailyNumber),
                isPremium: false,
                isLocked: false
            ))
        } else {
            // Ücretsiz kullanıcı: Sayı + kısa açıklama
            cards.append(NumerologyCard(
                id: "daily",
                title: "Günün Sayısı",
                number: dailyNumber,
                description: getDailyNumberShortDescription(for: dailyNumber),
                isPremium: false,
                isLocked: false
            ))
        }
        
        // 3. Kader Sayısı (PREMIUM) - İsim gerekli
        if let name = userName, !name.isEmpty {
            let destinyNumber = calculateDestinyNumber()
            let isLocked = !isPremiumUser
            print("📋 Kader Sayısı - isPremiumUser: \(isPremiumUser), isLocked: \(isLocked)")
            cards.append(NumerologyCard(
                id: "destiny",
                title: "Kader Sayın",
                number: (isPremiumUser && destinyNumber > 0) ? destinyNumber : nil,
                description: isPremiumUser ? (destinyNumber > 0 ? getDestinyDescription(for: destinyNumber) : "Hesaplanıyor...") : "Premium ile aç",
                isPremium: true,
                isLocked: isLocked
            ))
        } else {
            cards.append(NumerologyCard(
                id: "destiny",
                title: "Kader Sayın",
                number: nil,
                description: isPremiumUser ? "İsim gerekli" : "Premium ile aç",
                isPremium: true,
                isLocked: !isPremiumUser
            ))
        }
        
        // 4. Kalp / Ruh Sayısı (PREMIUM) - İsim gerekli
        if let name = userName, !name.isEmpty {
            let soulUrgeNumber = calculateSoulUrgeNumber()
            cards.append(NumerologyCard(
                id: "soulUrge",
                title: "Kalp Sayın",
                number: (isPremiumUser && soulUrgeNumber > 0) ? soulUrgeNumber : nil,
                description: isPremiumUser ? (soulUrgeNumber > 0 ? getSoulUrgeDescription(for: soulUrgeNumber) : "Hesaplanıyor...") : "Premium ile aç",
                isPremium: true,
                isLocked: !isPremiumUser
            ))
        } else {
            cards.append(NumerologyCard(
                id: "soulUrge",
                title: "Kalp Sayın",
                number: nil,
                description: isPremiumUser ? "İsim gerekli" : "Premium ile aç",
                isPremium: true,
                isLocked: !isPremiumUser
            ))
        }
        
        // 5. Kişilik Sayısı (PREMIUM) - İsim gerekli
        if let name = userName, !name.isEmpty {
            let personalityNumber = calculatePersonalityNumber()
            cards.append(NumerologyCard(
                id: "personality",
                title: "Kişilik Sayın",
                number: (isPremiumUser && personalityNumber > 0) ? personalityNumber : nil,
                description: isPremiumUser ? (personalityNumber > 0 ? getPersonalityDescription(for: personalityNumber) : "Hesaplanıyor...") : "Premium ile aç",
                isPremium: true,
                isLocked: !isPremiumUser
            ))
        } else {
            cards.append(NumerologyCard(
                id: "personality",
                title: "Kişilik Sayın",
                number: nil,
                description: isPremiumUser ? "İsim gerekli" : "Premium ile aç",
                isPremium: true,
                isLocked: !isPremiumUser
            ))
        }
        
        return cards
    }
    
    // MARK: - Calculation Methods
    
    func calculateLifePathNumber() -> Int {
        guard let birthDate = birthDate else { return 0 }
        
        // Numeroloji mantığı: Doğum tarihinin tüm rakamlarını TEK TEK topla
        // Örnek: 14.08.1996 -> 1+4+0+8+1+9+9+6 = 38 -> 3+8 = 11 -> 1+1 = 2
        
        // Tarihi string olarak formatla (gün ve ay 2 haneli olmalı)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: birthDate)
        
        // Tüm rakamları tek tek topla
        var sum = 0
        for char in dateString {
            if let digit = Int(String(char)) {
                sum += digit
            }
        }
        
        // Tek haneye düşür
        let result = reduceToSingleDigit(sum)
        return result > 0 ? result : 0
    }
    
    func calculateDestinyNumber() -> Int {
        guard let name = userName, !name.isEmpty else { return 0 }
        
        // İsim ve soyisim harflerini sayıya çevir
        let normalizedName = normalizeTurkishCharacters(name)
        let nameWithoutSpaces = normalizedName.replacingOccurrences(of: " ", with: "").uppercased()
        var sum = 0
        
        for char in nameWithoutSpaces {
            let letterValue = getLetterValue(char)
            if letterValue > 0 {
                sum += letterValue
            }
        }
        
        // Eğer hiç harf yoksa 0 döndür
        guard sum > 0 else { return 0 }
        
        // Tek haneye düşür
        let result = reduceToSingleDigit(sum)
        return result > 0 ? result : 0
    }
    
    func calculateSoulUrgeNumber() -> Int {
        guard let name = userName, !name.isEmpty else { return 0 }
        
        // Sadece sesli harfleri kullan
        let normalizedName = normalizeTurkishCharacters(name)
        let nameWithoutSpaces = normalizedName.replacingOccurrences(of: " ", with: "").uppercased()
        var sum = 0
        
        let vowels: Set<Character> = ["A", "E", "I", "O", "U"]
        
        for char in nameWithoutSpaces {
            if vowels.contains(char) {
                let letterValue = getLetterValue(char)
                if letterValue > 0 {
                    sum += letterValue
                }
            }
        }
        
        // Eğer hiç sesli harf yoksa 0 döndür
        guard sum > 0 else { return 0 }
        
        // Tek haneye düşür
        let result = reduceToSingleDigit(sum)
        return result > 0 ? result : 0
    }
    
    func calculatePersonalityNumber() -> Int {
        guard let name = userName, !name.isEmpty else { return 0 }
        
        // Sadece sessiz harfleri kullan
        let normalizedName = normalizeTurkishCharacters(name)
        let nameWithoutSpaces = normalizedName.replacingOccurrences(of: " ", with: "").uppercased()
        var sum = 0
        
        let vowels: Set<Character> = ["A", "E", "I", "O", "U"]
        
        for char in nameWithoutSpaces {
            // Sessiz harf kontrolü (sesli değilse)
            if !vowels.contains(char) {
                let letterValue = getLetterValue(char)
                if letterValue > 0 {
                    sum += letterValue
                }
            }
        }
        
        // Eğer hiç sessiz harf yoksa 0 döndür
        guard sum > 0 else { return 0 }
        
        // Tek haneye düşür
        let result = reduceToSingleDigit(sum)
        return result > 0 ? result : 0
    }
    
    func calculateDailyNumber() -> Int {
        let today = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: today)
        let month = calendar.component(.month, from: today)
        let year = calendar.component(.year, from: today)
        
        // Numeroloji mantığı: Tarihin tüm rakamlarını TEK TEK topla
        // Örnek: 02.01.2026 -> 0+2+0+1+2+0+2+6 = 13 -> 1+3 = 4
        // Örnek: 15.03.2026 -> 1+5+0+3+2+0+2+6 = 19 -> 1+9 = 10 -> 1+0 = 1
        
        // Tarihi string olarak formatla (gün ve ay 2 haneli olmalı)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: today)
        
        // Tüm rakamları tek tek topla
        var sum = 0
        for char in dateString {
            if let digit = Int(String(char)) {
                sum += digit
            }
        }
        
        // Tek haneye düşür
        return reduceToSingleDigit(sum)
    }
    
    // MARK: - Helper Methods
    
    private func sumOfDigits(_ number: Int) -> Int {
        var num = number
        var sum = 0
        while num > 0 {
            sum += num % 10
            num /= 10
        }
        return sum
    }
    
    func reduceToSingleDigit(_ number: Int) -> Int {
        var num = number
        while num > 9 {
            num = sumOfDigits(num)
        }
        return num
    }
    
    // MARK: - Harf-Sayı Dönüşümü
    
    private func normalizeTurkishCharacters(_ text: String) -> String {
        var normalized = text
        // Türkçe karakterleri normalize et
        normalized = normalized.replacingOccurrences(of: "İ", with: "I")
        normalized = normalized.replacingOccurrences(of: "ı", with: "i")
        normalized = normalized.replacingOccurrences(of: "Ö", with: "O")
        normalized = normalized.replacingOccurrences(of: "ö", with: "o")
        normalized = normalized.replacingOccurrences(of: "Ü", with: "U")
        normalized = normalized.replacingOccurrences(of: "ü", with: "u")
        normalized = normalized.replacingOccurrences(of: "Ç", with: "C")
        normalized = normalized.replacingOccurrences(of: "ç", with: "c")
        normalized = normalized.replacingOccurrences(of: "Ş", with: "S")
        normalized = normalized.replacingOccurrences(of: "ş", with: "s")
        normalized = normalized.replacingOccurrences(of: "Ğ", with: "G")
        normalized = normalized.replacingOccurrences(of: "ğ", with: "g")
        return normalized
    }
    
    private func getLetterValue(_ char: Character) -> Int {
        // Numeroloji harf-sayı tablosu
        let letterValueMap: [Character: Int] = [
            "A": 1, "B": 2, "C": 3, "D": 4, "E": 5,
            "F": 6, "G": 7, "H": 8, "I": 9,
            "J": 1, "K": 2, "L": 3, "M": 4,
            "N": 5, "O": 6, "P": 7, "Q": 8,
            "R": 9, "S": 1, "T": 2, "U": 3,
            "V": 4, "W": 5, "X": 6, "Y": 7, "Z": 8
        ]
        
        return letterValueMap[char] ?? 0
    }
    
    // MARK: - Descriptions
    
    private func getLifePathDescription(for number: Int) -> String {
        let descriptions = [
            1: "Doğal lider, bağımsız ve yaratıcı",
            2: "Dengeli, diplomatik ve işbirlikçi",
            3: "Yaratıcı, iletişimci ve neşeli",
            4: "Pratik, güvenilir ve çalışkan",
            5: "Özgür ruhlu, maceracı ve değişken",
            6: "Sorumlu, sevgi dolu ve koruyucu",
            7: "Ruhsal, analitik ve içe dönük",
            8: "Güçlü, başarı odaklı ve materyalist",
            9: "İnsancıl, cömert ve idealist"
        ]
        return descriptions[number] ?? "Bilinmeyen sayı"
    }
    
    private func getDestinyDescription(for number: Int) -> String {
        let descriptions = [
            1: "Liderlik ve bağımsızlık senin kaderin",
            2: "Uyum ve işbirliği senin yolun",
            3: "Yaratıcılık ve ifade senin gücün",
            4: "Stabilite ve güven senin temelin",
            5: "Özgürlük ve değişim senin ruhun",
            6: "Sevgi ve sorumluluk senin görevin",
            7: "Bilgelik ve içgörü senin armağanın",
            8: "Başarı ve güç senin hedefin",
            9: "Hizmet ve tamamlanma senin misyonun"
        ]
        return descriptions[number] ?? "Bilinmeyen sayı"
    }
    
    func getDailyNumberShortDescription(for number: Int) -> String {
        // Ücretsiz kullanıcılar için kısa açıklama (1 cümle)
        let shortDescriptions = [
            1: "Bugün yeni başlangıçlar için mükemmel. Detaylı yorum Premium'da.",
            2: "Bugün işbirliği ve denge zamanı. Detaylı yorum Premium'da.",
            3: "Bugün yaratıcılık ve iletişim ön planda. Detaylı yorum Premium'da.",
            4: "Bugün çalışma ve organizasyon günü. Detaylı yorum Premium'da.",
            5: "Bugün değişim ve macera seni bekliyor. Detaylı yorum Premium'da.",
            6: "Bugün sevgi ve sorumluluk önemli. Detaylı yorum Premium'da.",
            7: "Bugün içgörü ve analiz zamanı. Detaylı yorum Premium'da.",
            8: "Bugün başarı ve güç seninle. Detaylı yorum Premium'da.",
            9: "Bugün tamamlanma ve paylaşım günü. Detaylı yorum Premium'da."
        ]
        return shortDescriptions[number] ?? "Bilinmeyen sayı"
    }
    
    func getDailyNumberFullDescription(for number: Int) -> String {
        // Premium kullanıcılar için detaylı açıklama
        let fullDescriptions = [
            1: "Bugün yeni başlangıçlar için mükemmel. Yıldızlar senin için yeni bir sayfa açıyor. Cesaretle ilerle ve kalbinin sesini dinle. Bu gün aldığın kararlar geleceğini şekillendirecek.",
            2: "Bugün işbirliği ve denge zamanı. İlişkilerinde uyum ve anlayış ön planda. Birlikte çalışmak ve paylaşmak seni mutluluğa götürecek. Sabırlı ol ve dinlemeyi unutma.",
            3: "Bugün yaratıcılık ve iletişim ön planda. İfade gücün zirvede, fikirlerin parlak. Yaratıcı projeler için mükemmel bir gün. Neşeni paylaş ve içindeki sanatçıyı ortaya çıkar.",
            4: "Bugün çalışma ve organizasyon günü. Pratik adımlar at ve hedeflerine odaklan. Disiplin ve sabırla ilerlersen başarı seninle olacak. Detaylara dikkat et.",
            5: "Bugün değişim ve macera seni bekliyor. Rutinden çık ve yeni deneyimlere açık ol. Özgürlük ve keşif ruhun bugün çok güçlü. Cesaretle adım at.",
            6: "Bugün sevgi ve sorumluluk önemli. Ailen ve yakınların için zaman ayır. Sevgi dolu bir gün, paylaşım ve anlayış ön planda. Kalbinin sesini dinle.",
            7: "Bugün içgörü ve analiz zamanı. Derin düşünceler ve ruhsal arayışlar için ideal. Yalnız kalmak ve içe dönmek sana iyi gelecek. Bilgelik seninle.",
            8: "Bugün başarı ve güç seninle. Kariyer ve maddi konularda ilerleme zamanı. Hedeflerine odaklan ve güçlü adımlar at. Liderlik enerjin yüksek.",
            9: "Bugün tamamlanma ve paylaşım günü. Cömertlik ve hizmet ruhu ön planda. Başkalarına yardım etmek seni mutlu edecek. Bir döngü tamamlanıyor, yeni başlangıçlar yakın."
        ]
        return fullDescriptions[number] ?? "Bilinmeyen sayı"
    }
    
    private func getSoulUrgeDescription(for number: Int) -> String {
        let descriptions = [
            1: "İçsel liderlik ve bağımsızlık arzusu",
            2: "İçsel uyum ve işbirliği ihtiyacı",
            3: "İçsel yaratıcılık ve ifade gücü",
            4: "İçsel stabilite ve güven arayışı",
            5: "İçsel özgürlük ve macera tutkusu",
            6: "İçsel sevgi ve sorumluluk duygusu",
            7: "İçsel bilgelik ve ruhsal arayış",
            8: "İçsel güç ve başarı motivasyonu",
            9: "İçsel tamamlanma ve hizmet arzusu"
        ]
        return descriptions[number] ?? "Bilinmeyen sayı"
    }
    
    private func getPersonalityDescription(for number: Int) -> String {
        let descriptions = [
            1: "Dışa dönük liderlik ve güçlü karakter",
            2: "Dışa dönük uyum ve diplomatik yaklaşım",
            3: "Dışa dönük yaratıcılık ve sosyal enerji",
            4: "Dışa dönük pratiklik ve güvenilirlik",
            5: "Dışa dönük dinamizm ve değişkenlik",
            6: "Dışa dönük sevgi ve koruyuculuk",
            7: "Dışa dönük analitiklik ve derinlik",
            8: "Dışa dönük başarı odaklılık ve otorite",
            9: "Dışa dönük cömertlik ve idealizm"
        ]
        return descriptions[number] ?? "Bilinmeyen sayı"
    }
    
    // MARK: - Access Control
    
    func canAccessCard(withId cardId: String) -> Bool {
        // Yaşam Yolu ve Günün Sayısı herkes erişebilir
        if cardId == "lifePath" || cardId == "daily" {
            return true
        }
        // Diğerleri premium gerektirir
        return isPremiumUser
    }
    
    func canAccessFullDescription(for cardId: String) -> Bool {
        // Günün Sayısı için detaylı açıklama premium gerektirir
        if cardId == "daily" {
            return isPremiumUser
        }
        // Diğer kartlar için zaten premium kontrolü var
        return true
    }
    
    func checkAndRequestNameIfNeeded() -> Bool {
        if userName == nil || userName?.isEmpty == true {
            onNameRequired?()
            return false
        }
        return true
    }
    
    func checkAndRequestBirthDateIfNeeded() -> Bool {
        if birthDate == nil {
            onBirthDateRequired?()
            return false
        }
        return true
    }
    
    func saveUserName(_ name: String) {
        userName = name
        onDataUpdate?()
    }
    
    func saveBirthDate(_ date: Date) {
        birthDate = date
        onDataUpdate?()
    }
    
    func load() {
        // İsim kontrolü yap
        if userName == nil || userName?.isEmpty == true {
            onNameRequired?()
            return
        }
        
        // Doğum tarihi kontrolü yap
        if birthDate == nil {
            onBirthDateRequired?()
            return
        }
        
        onDataUpdate?()
    }
}

