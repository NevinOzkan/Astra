//
//  HomeViewModel.swift
//  Astra
//
//  Created by Nevin Özkan on 27.12.2025.
//

import Foundation

class HomeViewModel {
    
    var onTitleUpdate: ((String) -> Void)?
    
    init() {
        print("HomeViewModel oluşturuldu")
    }
    
    func load() {
        onTitleUpdate?("Ana Sayfa")
    }
}

