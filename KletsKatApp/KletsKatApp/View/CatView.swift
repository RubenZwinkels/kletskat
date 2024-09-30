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
    var eyeColor: Color = .black
    
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
                    .fill(catColor.opacity(0.6))
                    .frame(width: 50, height: 50)
                    .overlay(ear().stroke(catColor, lineWidth: 10))
                    .rotationEffect(.degrees(-35))


                Spacer().frame(width: 134)
                ear()
                    .fill(catColor.opacity(0.6))
                    .frame(width: 50, height: 50)
                    .overlay(ear().stroke(catColor, lineWidth: 10))
                    .rotationEffect(.degrees(35))
            }
            .padding(.top, -90)
        }
    }
    
    // functie voor het tekenen van een oortje
    func ear() -> Path {
            var path = Path()
            // Control points voor lichte buiging naar buiten
            let leftControlPoint = CGPoint(x: 10, y: 0)  // Controlepunt voor het linkeroor
            let rightControlPoint = CGPoint(x: 40, y: 0) // Controlepunt voor het rechteroor
            // Linker kant van het oor
            path.move(to: CGPoint(x: 0, y: 50)) // Start onderaan
            path.addQuadCurve(to: CGPoint(x: 25, y: 0), control: leftControlPoint) // Buiging naar links boven
            path.addQuadCurve(to: CGPoint(x: 50, y: 50), control: rightControlPoint) // Buiging naar rechts beneden

            return path
        }
}

#Preview {
    CatView(catColor: .orange)
}
