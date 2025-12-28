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
    
    private var selectedSign: ZodiacSign = ZodiacSign.allSigns[0] // Varsayılan: Koç
    private var compatibilityData: [Compatibility] = []
    
    var allSigns: [ZodiacSign] {
        return ZodiacSign.allSigns
    }
    
    var currentSelectedSign: ZodiacSign {
        return selectedSign
    }
    
    var compatibilities: [Compatibility] {
        return compatibilityData
    }
    
    func selectSign(_ sign: ZodiacSign) {
        selectedSign = sign
        loadCompatibilityData(for: sign)
    }
    
    func loadCompatibilityData(for sign: ZodiacSign) {
        // TODO: JSON'dan gerçek data yüklenecek
        // Şimdilik mock data
        generateMockData(for: sign)
    }
    
    private func generateMockData(for sign: ZodiacSign) {
        var mockData: [Compatibility] = []
        
        for otherSign in ZodiacSign.allSigns where otherSign.name != sign.name {
            // Rastgele uyum değerleri (gerçek uygulamada JSON'dan gelecek)
            let love = Int.random(in: 50...95)
            let friendship = Int.random(in: 55...90)
            let work = Int.random(in: 60...95)
            
            mockData.append(Compatibility(
                sign: otherSign.name,
                love: love,
                friendship: friendship,
                work: work
            ))
        }
        
        compatibilityData = mockData.sorted { $0.sign < $1.sign }
        onDataUpdate?()
    }
    
    func load() {
        loadCompatibilityData(for: selectedSign)
    }
}

