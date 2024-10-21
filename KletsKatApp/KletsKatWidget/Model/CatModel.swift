//
//  CatModel.swift
//  KletsKatApp
//
//  Created by Ruben Zwinkels on 17/10/2024.
//

import Foundation
import SwiftUI

class CatModel: ObservableObject {
    static let shared = CatModel()
    @Published var color: Color
    @Published var eyeColor: Color
    @Published var name: String
    @Published var bond: Int
    @Published var personality: Personality
    
    init(color: Color = .gray, eyeColor: Color = .green, name: String = "Unknown", bond: Int = 50, personality: Personality = .happy) {
        self.color = color
        self.eyeColor = eyeColor
        self.name = name
        self.bond = bond
        self.personality = personality
    }
}
