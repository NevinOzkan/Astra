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
        guard let data = compatibilityData else { return "" }
        let avg = overallPercentage
        
        if avg >= 85 {
            return "Bu iki burç arasında güçlü bir iletişim ve duygusal bağ bulunmaktadır. Birlikte çalıştıklarında harika sonuçlar elde edebilirler ve birbirlerini destekleyerek büyüyebilirler."
        } else if avg >= 70 {
            return "Bu iki burç arasında dengeli bir uyum vardır. Farklılıkları birbirlerini tamamlayarak güçlü bir ilişki kurabilirler. İletişim ve anlayış ile uyumları daha da artabilir."
        } else {
            return "Bu iki burç arasında bazı zorluklar olabilir, ancak karşılıklı saygı ve anlayış ile güçlü bir bağ kurabilirler. Sabır ve iletişim önemlidir."
        }
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
        // Mock data - gerçek uygulamada JSON'dan gelecek
        // Şimdilik partnerSign'a göre rastgele değerler
        let love = Int.random(in: 60...95)
        let friendship = Int.random(in: 55...90)
        let work = Int.random(in: 65...95)
        
        return Compatibility(
            sign: partnerSign.name,
            love: love,
            friendship: friendship,
            work: work
        )
    }
    
    func load() {
        onDataUpdate?()
    }
}

