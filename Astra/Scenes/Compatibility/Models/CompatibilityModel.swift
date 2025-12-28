//
//  CompatibilityModel.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import Foundation

struct CompatibilityResponse: Codable {
    let sourceSign: String
    let compatibilities: [Compatibility]
}

struct Compatibility: Codable {
    let sign: String
    let love: Int
    let friendship: Int
    let work: Int
}

struct ZodiacSign {
    let name: String
    let symbol: String
    let emoji: String
    
    static let allSigns: [ZodiacSign] = [
        ZodiacSign(name: "Koç", symbol: "♈", emoji: "♈"),
        ZodiacSign(name: "Boğa", symbol: "♉", emoji: "♉"),
        ZodiacSign(name: "İkizler", symbol: "♊", emoji: "♊"),
        ZodiacSign(name: "Yengeç", symbol: "♋", emoji: "♋"),
        ZodiacSign(name: "Aslan", symbol: "♌", emoji: "♌"),
        ZodiacSign(name: "Başak", symbol: "♍", emoji: "♍"),
        ZodiacSign(name: "Terazi", symbol: "♎", emoji: "♎"),
        ZodiacSign(name: "Akrep", symbol: "♏", emoji: "♏"),
        ZodiacSign(name: "Yay", symbol: "♐", emoji: "♐"),
        ZodiacSign(name: "Oğlak", symbol: "♑", emoji: "♑"),
        ZodiacSign(name: "Kova", symbol: "♒", emoji: "♒"),
        ZodiacSign(name: "Balık", symbol: "♓", emoji: "♓")
    ]
}

