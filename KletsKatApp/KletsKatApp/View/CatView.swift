//
//  CatView.swift
//  KletsKatApp
//
//  Created by Ruben Zwinkels on 28/09/2024.
//

import SwiftUI
import Foundation

struct CatView: View {
    var catColor: Color
    var eyeColor: Color = .black // Toevoegen van een parameter voor oogkleur
    
    var body: some View {
        // Hoofdje van de kat
        ZStack {
            // Hoofd
            Ellipse()
                .fill(catColor)
                .frame(width: 220, height: 150)

            // Ogen
            HStack {
                ZStack {
                    Circle()
                        .fill(eyeColor)
                        .frame(width: 35)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(eyeColor)
                        .frame(width: 35)
                }
            }
            .padding(.horizontal, 37)
            .frame(width: 200)
            
            // Oren
            HStack {
                ear()
                    .fill(catColor) // Kleur van het oor is gelijk aan de kleur van de kat
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-30)) // Draai het linker oor
                Spacer().frame(width: 134)
                ear()
                    .fill(catColor) // Kleur van het oor is gelijk aan de kleur van de kat
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(30))
            }
            .padding(.top, -90) // Zorg dat de oren boven het hoofdje verschijnen
        }
    }
    
    // Functie voor het tekenen van een oor
    func ear() -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 25, y: 0)) // Beginpunt van het oor
        path.addLine(to: CGPoint(x: 0, y: 50)) // Linker onderkant
        path.addLine(to: CGPoint(x: 50, y: 50)) // Rechter onderkant
        path.addLine(to: CGPoint(x: 25, y: 0)) // Terug naar beginpunt
        return path
    }
}

#Preview {
    CatView(catColor: .orange)
}
