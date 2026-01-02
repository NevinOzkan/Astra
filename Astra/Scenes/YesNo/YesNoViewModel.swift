//
//  YesNoViewModel.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import Foundation

enum YesNoCard: String, CaseIterable {
    case yes = "Evet"
    case no = "Hayır"
    
    var title: String {
        return self.rawValue
    }
    
    var messages: [String] {
        switch self {
        case .yes:
            return [
                "Evet.\nBu isteği aklına getiren şey rastlantı değil.\nBir süredir içinden yükselen o dürtüyü bastırmaya çalışıyorsun ama farkındasın: erteledikçe rahatlamıyorsun.\nŞu an önünde duran kapı, cesaretle açılmayı bekliyor.\nAdım attığında yol kendini gösterecek.",
                
                "Evet.\nBu konuda kararsız hissetmen yanlış yolda olduğun anlamına gelmiyor.\nTam tersine, bu karar senin için önemli olduğu için durup düşünüyorsun.\nKorku, riskin değil değerin göstergesi.\nKendine güven ve ilerle.",
                
                "Evet.\nZamanlama sandığından daha uygun.\nHazır hissetmemek, hazır olmadığın anlamına gelmez.\nBu deneyim seni büyütecek,\ngeri çekilmek ise aynı yerde kalmana neden olacak.",
                
                "Evet.\nBu soruyu sormana sebep olan şey,\nzaten çoktan yola çıkmak istediğini gösteriyor.\nOnay arıyorsun ama ihtiyacın olan tek şey\nkendi kararına sahip çıkmak.",
                
                "Evet.\nBu seçim seni konfor alanının dışına çıkaracak,\nama tam da orada dönüşüm başlar.\nKontrol etmeye çalışmayı bırak\nve sürecin seni taşımasına izin ver."
            ]
        case .no:
            return [
                "Hayır.\nBu yolda ilerlemek seni güçlendirmiyor,\nsadece daha fazla yoruyor.\nBir şeyleri zorlamak yerine\nneden bu kadar zorlandığını fark etmenin zamanı.",
                
                "Hayır.\nŞu an aldığın sinyaller net.\nİçindeki huzursuzluk tesadüf değil.\nKendini ikna ederek devam etmek,\nsorunu çözmez, sadece erteler.",
                
                "Hayır.\nBu karar sana ait değilmiş gibi hissediyorsun\nçünkü gerçekten de öyle.\nBaşkalarının beklentileriyle şekillenen bir yol\nseni uzun vadede tatmin etmeyecek.",
                
                "Hayır.\nDurmak başarısızlık değil.\nBazen en cesur hamle,\nyanlış bir yoldan geri dönebilmektir.\nŞu an buna ihtiyacın var.",
                
                "Hayır.\nHenüz doğru şartlar oluşmadı.\nZamanı gelmeden atılan adımlar\ngereksiz kayıplara yol açar.\nBiraz geri çekil ve bekle."
            ]
        }
    }
}

class YesNoViewModel {
    
    var onCardSelected: ((YesNoCard, String) -> Void)? // Card ve mesaj
    var onError: ((String) -> Void)?
    
    private(set) var selectedCard: YesNoCard?
    private var messageCache: [YesNoCard: String] = [:] // Her kart için cache'lenmiş mesaj
    
    var availableCards: [YesNoCard] {
        return YesNoCard.allCases
    }
    
    func selectCard(_ card: YesNoCard) {
        selectedCard = card
        
        // Cache'den mesaj al veya yeni seç
        let message: String
        if let cachedMessage = messageCache[card] {
            message = cachedMessage
        } else {
            message = card.messages.randomElement() ?? card.messages[0]
            messageCache[card] = message
        }
        
        onCardSelected?(card, message)
    }
    
    func resetSelection() {
        selectedCard = nil
    }
    
    func getMessage(for card: YesNoCard) -> String {
        if let cachedMessage = messageCache[card] {
            return cachedMessage
        } else {
            let message = card.messages.randomElement() ?? card.messages[0]
            messageCache[card] = message
            return message
        }
    }
}

