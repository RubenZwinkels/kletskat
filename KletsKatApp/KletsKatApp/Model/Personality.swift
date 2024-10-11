//
//  Personality.swift
//  KletsKatApp
//
//  Created by Ruben Zwinkels on 02/10/2024.
//

enum Personality: String, Decodable, CaseIterable {
    case grumpy = "grumpy"
    case happy = "happy"
    case lover = "lover"
    case joker = "joker"

    // Initializer om een string naar de juiste Personality enum waarde te converteren
    init?(from string: String) {
        switch string.lowercased() {
        case "grumpy":
            self = .grumpy
        case "happy":
            self = .happy
        case "lover":
            self = .lover
        case "joker":
            self = .joker
        default:
            return nil // Ongeldige string waarde
        }
    }
}
