//
//  CompatibilityViewModel.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import Foundation

class CompatibilityViewModel {
    
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private var userSign: ZodiacSign = ZodiacSign.allSigns[0] // Kullanıcının burcu (varsayılan: Koç)
    private var partnerSign: ZodiacSign = ZodiacSign.allSigns[1] // Karşı burç (varsayılan: Boğa)
    private var compatibilityDataCache: [CompatibilityResponse] = []
    private var commentCache: [String: String] = [:] // Cache key: "userSign-partnerSign"
    
    var allSigns: [ZodiacSign] {
        return ZodiacSign.allSigns
    }
    
    var currentUserSign: ZodiacSign {
        return userSign
    }
    
    var currentPartnerSign: ZodiacSign {
        return partnerSign
    }
    
    var compatibilityData: Compatibility? {
        return getCompatibilityData()
    }
    
    var overallPercentage: Int {
        guard let data = compatibilityData else { return 0 }
        return (data.love + data.friendship + data.work) / 3
    }
    
    var generalComment: String {
        guard let _ = compatibilityData else { return "" }
        
        // Cache key oluştur
        let cacheKey = "\(userSign.name)-\(partnerSign.name)"
        
        // Cache'den kontrol et
        if let cachedComment = commentCache[cacheKey] {
            return cachedComment
        }
        
        // Yeni yorum oluştur
        let avg = overallPercentage
        let comments: [String]
        
        switch avg {
        case 90...100:
            comments = [
                "Bu iki burç arasında oldukça doğal ve akıcı bir uyum var. İletişim zahmetsiz ilerler ve taraflar kendilerini rahatça ifade edebilir.",
                "Yüksek bir uyum söz konusu. Birlikteyken enerji kolayca yakalanır ve uzun vadeli bir bağ kurma potansiyeli dikkat çeker.",
                "Bu ilişki, karşılıklı anlayış ve güçlü iletişim üzerine kuruludur. Zamanla daha da sağlamlaşabilir."
            ]
            
        case 80..<90:
            comments = [
                "Bu iki burç arasında güçlü bir çekim ve karşılıklı denge bulunur. Küçük farklılıklar ilişkiyi besleyebilir.",
                "Genel uyum oldukça iyi seviyededir. Zaman zaman fikir ayrılıkları yaşansa da, iletişimle kolayca aşılabilir.",
                "Birbirini tamamlayan yönler öne çıkıyor. Doğru yaklaşım ile uyum uzun vadede korunabilir."
            ]
            
        case 70..<80:
            comments = [
                "Bu iki burç arasında dengeli fakat emek isteyen bir uyum vardır. Açık iletişim ilişkiyi güçlendirebilir.",
                "Farklı bakış açıları zaman zaman zorlayıcı olabilir, ancak doğru denge kurulduğunda ilişki gelişebilir.",
                "Uyum orta seviyededir. Tarafların beklentilerini netleştirmesi önemlidir."
            ]
            
        case 60..<70:
            comments = [
                "Bu iki burç arasında belirgin farklılıklar bulunur. Sabır ve anlayış olmadan ilerlemek zor olabilir.",
                "İlk etapta uyum yakalamak kolay olmayabilir, ancak zamanla orta seviyede bir denge kurulabilir.",
                "Bu ilişki, karşılıklı çaba gerektiren bir yapıya sahiptir."
            ]
            
        case 50..<60:
            comments = [
                "Uyum inişli çıkışlı bir yapı gösterebilir. İletişim eksikliği sorunlara yol açabilir.",
                "Tarafların birbirini anlaması için ekstra çaba göstermesi gerekir.",
                "Bu ilişki büyük ölçüde beklentilerin nasıl yönetildiğine bağlıdır."
            ]
            
        default:
            comments = [
                "Bu iki burç arasında doğal bir uyumdan söz etmek zor olabilir.",
                "Farklı karakter yapıları ilişkiyi zorlayabilir.",
                "Ancak karşılıklı saygı ile belirli bir denge yakalanabilir."
            ]
        }
        
        // Rastgele bir yorum seç ve cache'e ekle
        let selectedComment = comments.randomElement() ?? ""
        commentCache[cacheKey] = selectedComment
        
        return selectedComment
    }
    
    func selectUserSign(_ sign: ZodiacSign) {
        userSign = sign
        onDataUpdate?()
    }
    
    func selectPartnerSign(_ sign: ZodiacSign) {
        partnerSign = sign
        onDataUpdate?()
    }
    
    private func getCompatibilityData() -> Compatibility? {
        // JSON'dan veri yükle
        guard let response = loadCompatibilityData(for: userSign.name) else {
            // Fallback: Mock data
            return Compatibility(
                sign: partnerSign.name,
                love: Int.random(in: 60...95),
                friendship: Int.random(in: 55...90),
                work: Int.random(in: 65...95)
            )
        }
        
        // Partner sign'a göre uyum verisini bul
        if let compatibility = response.compatibilities.first(where: { $0.sign == partnerSign.name }) {
            return compatibility
        }
        
        // Fallback: Mock data
        return Compatibility(
            sign: partnerSign.name,
            love: Int.random(in: 60...95),
            friendship: Int.random(in: 55...90),
            work: Int.random(in: 65...95)
        )
    }
    
    private func loadCompatibilityData(for sourceSign: String) -> CompatibilityResponse? {
        // Cache'den kontrol et
        if let cached = compatibilityDataCache.first(where: { $0.sourceSign == sourceSign }) {
            return cached
        }
        
        // JSON dosyasını yükle
        guard let path = Bundle.main.path(forResource: "compatibility", ofType: "json", inDirectory: "JSON") else {
            print("⚠️ Compatibility JSON dosyası bulunamadı")
            onError?("Compatibility verileri yüklenemedi")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url),
              let responses = try? JSONDecoder().decode([CompatibilityResponse].self, from: data) else {
            onError?("Compatibility verileri yüklenemedi")
            return nil
        }
        
        // Cache'e ekle
        compatibilityDataCache = responses
        
        // İstenen sign'ı bul ve döndür
        return responses.first(where: { $0.sourceSign == sourceSign })
    }
    
    func load() {
        // İlk yüklemede cache'i doldur
        _ = loadCompatibilityData(for: userSign.name)
        onDataUpdate?()
    }
}

