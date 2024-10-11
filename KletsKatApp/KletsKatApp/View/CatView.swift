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
                .stroke(accentColor, lineWidth: 10)
                .fill(catColor)
                .frame(width: 220, height: 150)

            // Ogen
            HStack {
                    Circle()
                        .fill(eyeColor)
                        .frame(width: 35)
                Spacer()
                    Circle()
                        .fill(eyeColor)
                        .frame(width: 35)
            }
            .padding(.horizontal, 37)
            .frame(width: 200)

            // Gezichtje
            VStack {
                // Neusje en snorharen
                HStack {
                    // Snorharen links
                    VStack(spacing: 4) {
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
                    .padding(.trailing, 10)

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
                    .padding(.leading, 10)
                }

                // Mondje met twee halve cirkels
                HStack {
                    Spacer()
                    halfCircle() // Linker halve cirkel
                        .stroke(accentColor, lineWidth: 5)
                    halfCircle() // Rechter halve cirkel
                        .stroke(accentColor, lineWidth: 5)
                        .scaleEffect(x: -1, y: 1)
                    Spacer()
                }
                .frame(width: 40) // Pas de breedte aan om ruimte tussen de cirkels te verminderen
            }
            .frame(width: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
            .offset(y: 33)

            // Oren
            HStack {
                ear()
                    .stroke(accentColor, lineWidth: 10)
                    .fill(catColor.opacity(0.6))
                    .frame(width: 50, height: 50)
                    .overlay(ear().stroke(catColor, lineWidth: 10))
                    .rotationEffect(.degrees(-35))

                Spacer().frame(width: 134)
                ear()
                    .stroke(accentColor, lineWidth: 10)
                    .fill(catColor.opacity(0.6))
                    .frame(width: 50, height: 50)
                    .overlay(ear().stroke(catColor, lineWidth: 10))
                    .rotationEffect(.degrees(35))
            }
            .padding(.top, -90)
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

    // Functie voor het tekenen van een halve cirkel (op zijn kop)
    func halfCircle() -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: 0, y: 0), // Gecentreerd voor de halve cirkel
                    radius: 10, // Radius van de halve cirkel
                    startAngle: Angle(degrees: 0), // Starten vanaf de bovenkant
                    endAngle: Angle(degrees: 180), // Einde aan de onderkant
                    clockwise: false) // Tegen de klok in
        return path
    }
}

#Preview {
    CatView(catColor: .orange)
}
