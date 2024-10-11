import SwiftUI
import Foundation

struct CustomizeCatView: View {
    @ObservedObject var catController = CatController.shared
    @State private var catColor: Color = .orange
    @State private var eyeColor: Color = .black
    @State private var catName: String = "Simba"
    @State private var catPersonality: Personality = .happy
    
    let availableColors: [Color] = [.orange, .yellow, .white, .black, .gray, .brown]
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea() // achtergrond
            VStack {
                CatView(catColor: catColor, eyeColor: eyeColor)
                HStack {
                    ForEach(availableColors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                catColor = color
                            }
                            .overlay(
                                Circle()
                                    .stroke(catColor == color ? Color.black : Color.clear, lineWidth: 3)
                            )
                    }
                }
                .padding()

            }
            .onAppear {
                self.catColor = catController.catModel.color
                self.eyeColor = catController.catModel.eyeColor
                self.catName = catController.catModel.name
                self.catPersonality = catController.catModel.personality
            }
        }
    }
}

#Preview {
    CustomizeCatView()
}
