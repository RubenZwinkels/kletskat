import SwiftUI
import Foundation

struct CatView: View {
    var catColor: Color
    var eyeColor: Color = .black
    var accentColor: Color = Color(red: 87/255, green: 86/255, blue: 86/255)

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
            
            // Gezichtje
            VStack {
                // Neusje en snorharen
                HStack {
                    // Snorharen links
                    VStack(spacing: 4) { // verticale ruimte tussen snorharen
                        wisker()
                            .stroke(accentColor, lineWidth: 2)
                            .frame(height: 2)
                            .rotationEffect(.degrees(10))
                        wisker()
                            .stroke(accentColor, lineWidth: 2)
                            .frame(height: 2)
                        wisker()
                            .stroke(accentColor, lineWidth: 2)
                            .frame(height: 2)
                            .rotationEffect(.degrees(-10))
                    }
                    .padding(.trailing, 10) // padding om ze naar binnen te doen
                    
                    // Neusje
                    Ellipse()
                        .fill(accentColor)
                        .frame(width: 25, height: 15)
                    
                    // Snorharen rechts
                    VStack(spacing: 4) {
                        wisker()
                            .stroke(accentColor, lineWidth: 2)
                            .frame(height: 2)
                            .rotationEffect(.degrees(10))
                            .scaleEffect(x: -1, y: 1)
                        wisker()
                            .stroke(accentColor, lineWidth: 2)
                            .frame(height: 2)
                            .scaleEffect(x: -1, y: 1)
                        wisker()
                            .stroke(accentColor, lineWidth: 2)
                            .frame(height: 2)
                            .rotationEffect(.degrees(-10))
                            .scaleEffect(x: -1, y: 1)

                    }
                    .padding(.leading, 10) // snorharen naar links
                }
            }
            .frame(width: 175)
            .padding(.top, 80)
        }
    }
    
    // Functie voor het tekenen van een oortje
    func ear() -> Path {
        var path = Path()
        let leftControlPoint = CGPoint(x: 10, y: 0)
        let rightControlPoint = CGPoint(x: 40, y: 0)
        path.move(to: CGPoint(x: 0, y: 50))
        path.addQuadCurve(to: CGPoint(x: 25, y: 0), control: leftControlPoint)
        path.addQuadCurve(to: CGPoint(x: 50, y: 50), control: rightControlPoint)
        return path
    }
    
    // Aangepaste functie voor de snorharen
    func wisker() -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: 30, y: 0),
            control: CGPoint(x: 15, y: -10)
        )
        return path
    }
}

#Preview {
    CatView(catColor: .orange)
}
