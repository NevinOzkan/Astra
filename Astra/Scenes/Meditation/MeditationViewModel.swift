//
//  MeditationViewModel.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import Foundation

struct MeditationCard {
    let id: String
    let title: String
    let subtitle: String
    let isPremium: Bool
}

class MeditationViewModel {
    
    private let premiumManager = PremiumManager.shared
    
    // Constants
    private let freeUsageLimit = 3
    private let usageCountKey = "zodiacMeditationUsageCount"
    
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    var isPremiumUser: Bool {
        return premiumManager.isPremiumUser
    }
    
    var zodiacMeditationUsageCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: usageCountKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: usageCountKey)
        }
    }
    
    var availableCards: [MeditationCard] {
        return [
            MeditationCard(
                id: "zodiac",
                title: "Burca Göre Meditasyon",
                subtitle: getZodiacMeditationSubtitle(),
                isPremium: false
            ),
            MeditationCard(
                id: "daily",
                title: "Günün Enerjisi Meditasyonu",
                subtitle: "Premium",
                isPremium: true
            )
        ]
    }
    
    private func getZodiacMeditationSubtitle() -> String {
        if isPremiumUser {
            return "Premium"
        }
        
        let usage = zodiacMeditationUsageCount
        if usage >= freeUsageLimit {
            return "Premium gerekli"
        }
        
        if usage == freeUsageLimit - 1 {
            return "Son ücretsiz meditasyonun"
        }
        
        return "Ücretsiz kullanım: \(usage + 1)/\(freeUsageLimit)"
    }
    
    // MARK: - Zodiac Meditation Access Control
    
    func canAccessZodiacMeditation() -> Bool {
        // Premium kullanıcı her zaman erişebilir
        if isPremiumUser {
            return true
        }
        
        // Ücretsiz kullanım limiti kontrolü
        return zodiacMeditationUsageCount < freeUsageLimit
    }
    
    func increaseZodiacMeditationUsage() {
        // Premium kullanıcı için sayaç artırılmaz
        guard !isPremiumUser else { return }
        
        let currentCount = zodiacMeditationUsageCount
        if currentCount < freeUsageLimit {
            zodiacMeditationUsageCount = currentCount + 1
            onDataUpdate?()
        }
    }
    
    func canAccessDailyMeditation() -> Bool {
        // Günün enerjisi meditasyonu her zaman premium
        return isPremiumUser
    }
    
    func load() {
        onDataUpdate?()
    }
}

