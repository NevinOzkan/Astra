//
//  PremiumManager.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import Foundation

class PremiumManager {
    
    static let shared = PremiumManager()
    
    private let premiumKey = "isPremiumUser"
    
    private init() {}
    
    var isPremiumUser: Bool {
        get {
            return UserDefaults.standard.bool(forKey: premiumKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: premiumKey)
        }
    }
    
    func setPremium(_ isPremium: Bool) {
        isPremiumUser = isPremium
    }
}

