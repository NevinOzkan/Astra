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
    case maybe = "Belki"
    
    var title: String {
        return self.rawValue
    }
    
    var messages: [String] {
        switch self {
        case .yes:
            return [
                "Evet, bu senin için doğru seçim. Yüreğinin sesini dinle ve ilerle.",
                "Evet, yıldızlar seninle. Bu yol senin için açık ve net.",
                "Evet, içgüdülerin doğru yönlendiriyor. Güven ve adım at.",
                "Evet, bu fırsat senin için hazırlanmış. Cesaretle ilerle.",
                "Evet, enerjiler senin lehine. Bu seçim seni mutluluğa götürecek."
            ]
        case .no:
            return [
                "Hayır, şu an için bu yol senin için değil. Zamanı geldiğinde doğru fırsat çıkacak.",
                "Hayır, şimdi değil. Evren sana daha iyi bir zaman hazırlıyor.",
                "Hayır, bu seçim şu an için senin enerjine uygun değil. Sabırlı ol.",
                "Hayır, yıldızlar farklı bir yön gösteriyor. Başka bir fırsatı bekle.",
                "Hayır, bu yol şu an kapalı. Doğru zaman geldiğinde kapılar açılacak."
            ]
        case .maybe:
            return [
                "Belki, henüz net değil. Biraz daha düşün ve iç sesini dinle.",
                "Belki, zaman henüz olgunlaşmadı. Biraz daha beklemek gerekebilir.",
                "Belki, koşullar değişiyor. Bir süre daha gözlemle ve karar ver.",
                "Belki, şu an için belirsizlik var. İç sesinle daha fazla bağlantı kur.",
                "Belki, evren sana daha fazla bilgi vermek için bekliyor. Sabırlı ol."
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

