import Foundation
import SwiftUI

struct HomeView: View {
    @ObservedObject var catController = CatController.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea() // achtergrond
                VStack {
                    Text("Welkom terug!").padding(.top, 100)
                    CatView(catColor: catController.catModel.color)
                    
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
    }
}

#Preview {
    HomeView()
}
