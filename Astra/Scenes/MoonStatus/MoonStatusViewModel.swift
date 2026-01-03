//
//  MoonStatusViewModel.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import Foundation

class MoonStatusViewModel {
    
    var currentPhase: MoonPhase {
        return MoonPhase.currentPhase()
    }
    
    var isPremiumUser: Bool {
        return PremiumManager.shared.isPremiumUser
    }
    
    var phaseEmoji: String {
        return currentPhase.emoji
    }
    
    var phaseName: String {
        return currentPhase.rawValue
    }
    
    var freeDescription: String {
        return currentPhase.freeDescription
    }
    
    var premiumDescription: String {
        return currentPhase.premiumDescription
    }
    
    var description: String {
        if isPremiumUser {
            return currentPhase.premiumDescription
        } else {
            return currentPhase.freeDescription
        }
    }
    
    var isContentLocked: Bool {
        return !isPremiumUser
    }
    
    var impactAreas: [(emoji: String, title: String)] {
        return currentPhase.impactAreas
    }
    
    var effectDuration: String {
        return currentPhase.effectDuration
    }
    
    var premiumContent: (love: String, work: String, ritual: String) {
        return currentPhase.premiumContent
    }
    
    func unlockPremium(completion: @escaping () -> Void) {
        // Premium satın alma işlemi burada yapılabilir
        // Şimdilik sadece callback çağırıyoruz
        completion()
    }
}

