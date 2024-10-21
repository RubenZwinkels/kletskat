import SwiftUI
import Foundation

struct WidgetCatView: View {
    var catColor: Color
    var eyeColor: Color = .black
    var accentColor: Color = Color(red: 87/255, green: 86/255, blue: 86/255)

    var body: some View {
        // Hoofdje van de kat
        ZStack {
            // Hoofd
            Ellipse()
                .stroke(accentColor, lineWidth: 5)
                .fill(catColor)
                .frame(width: 110, height: 75) // Hoofd afmetingen

            // Ogen
            HStack {
                Circle()
                    .fill(eyeColor)
                    .frame(width: 15) // Oog afmetingen
                Spacer()
                Circle()
                    .fill(eyeColor)
                    .frame(width: 15) // Oog afmetingen
            }
            .padding(.horizontal, 18)
            .frame(width: 100)

            // Gezichtje
            VStack(spacing: 0) {
                // Neusje en snorharen
                HStack {
                    // Snorharen links
                    VStack(spacing: 2) {
                        wisker()
                            .stroke(accentColor, lineWidth: 1)
                            .frame(height: 1)
                            .rotationEffect(.degrees(10))
                        wisker()
                            .stroke(accentColor, lineWidth: 1)
                            .frame(height: 1)
                        wisker()
                            .stroke(accentColor, lineWidth: 1)
                            .frame(height: 1)
                            .rotationEffect(.degrees(-10))
                    }
                    .padding(.trailing, 5)

                    // Neusje
                    Ellipse()
                        .fill(accentColor)
                        .frame(width: 15, height: 10)

                    // Snorharen rechts
                    VStack(spacing: 2) {
                        wisker()
                            .stroke(accentColor, lineWidth: 1)
                            .frame(height: 1)
                            .rotationEffect(.degrees(10))
                            .scaleEffect(x: -1, y: 1)
                        wisker()
                            .stroke(accentColor, lineWidth: 1)
                            .frame(height: 1)
                            .scaleEffect(x: -1, y: 1)
                        wisker()
                            .stroke(accentColor, lineWidth: 1)
                            .frame(height: 1)
                            .rotationEffect(.degrees(-10))
                            .scaleEffect(x: -1, y: 1)
                    }
                    .padding(.leading, 5)
                }
                .offset(y: -5) // Verplaats neus en snorharen naar boven

                // Mondje met twee halve cirkels
                HStack(spacing: -18) { // Verminder de ruimte tussen de halve cirkels
                    halfCircle() // Linker halve cirkel
                        .stroke(accentColor, lineWidth: 3)
                        .frame(width: 15, height: 10) // Pas de grootte aan
                    halfCircle() // Rechter halve cirkel
                        .stroke(accentColor, lineWidth: 3)
                        .frame(width: 15, height: 10) // Pas de grootte aan
                        .scaleEffect(x: -1, y: 1)
                }
                .frame(width: 30) // Frame breedte om ruimte tussen de cirkels te verminderen
                .offset(y: 2) // Verplaats het mondje iets naar beneden
            }
            .frame(width: 125, height: 30)
            .offset(y: 15) // Verplaats het gezichtje naar beneden

            // Oren
            HStack {
                ear()
                    .stroke(accentColor, lineWidth: 7)
                    .fill(catColor.opacity(0.6))
                    .frame(width: 25, height: 25)
                    .overlay(ear().stroke(catColor, lineWidth: 5))
                    .rotationEffect(.degrees(-35))

                Spacer().frame(width: 70)
                ear()
                    .stroke(accentColor, lineWidth: 7)
                    .fill(catColor.opacity(0.6))
                    .frame(width: 25, height: 25)
                    .overlay(ear().stroke(catColor, lineWidth: 5))
                    .rotationEffect(.degrees(35))
            }
            .padding(.top, -40)
        }
    }

    // Functie voor het tekenen van een oortje
    func ear() -> Path {
        var path = Path()
        let leftControlPoint = CGPoint(x: 5, y: 0)
        let rightControlPoint = CGPoint(x: 20, y: 0)
        path.move(to: CGPoint(x: 0, y: 25))
        path.addQuadCurve(to: CGPoint(x: 12.5, y: 0), control: leftControlPoint)
        path.addQuadCurve(to: CGPoint(x: 25, y: 25), control: rightControlPoint)
        return path
    }

    // Aangepaste functie voor de snorharen
    func wisker() -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: 15, y: 0),
            control: CGPoint(x: 7.5, y: -5)
        )
        return path
    }

    // Functie voor het tekenen van een halve cirkel (op zijn kop)
    func halfCircle() -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: 0, y: 0), // Gecentreerd voor de halve cirkel
                    radius: 5, // Radius van de halve cirkel
                    startAngle: Angle(degrees: 0), // Starten vanaf de bovenkant
                    endAngle: Angle(degrees: 180), // Einde aan de onderkant
                    clockwise: false) // Tegen de klok in
        return path
    }
}

#Preview {
    WidgetCatView(catColor: .orange)
}
