import Foundation
import SwiftUI

struct HomeView: View {
    @ObservedObject var catController = CatController.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea() // achtergrond
                VStack {
                    Text("Welkom terug! \(catController.catModel.name) heeft op je gewacht!").padding(.top, 100)
                    CatView(catColor: catController.catModel.color, eyeColor: catController.catModel.eyeColor)
                    
                    // pennetje om te navigeren naar customizeCatView
                    NavigationLink(destination: CustomizeCatView()) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.highlight)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
