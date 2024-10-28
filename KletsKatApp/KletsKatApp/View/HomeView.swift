import Foundation
import SwiftUI

struct HomeView: View {
    @ObservedObject var catController = CatController.shared
    @ObservedObject var tokenManager = TokenManager()
    @State private var isNavigate: Bool = false // state om terug te navigeren naar ContentView
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea() // achtergrond
                
                VStack {
                    HStack {
                        Spacer()
                        // Navigatie link voor de uitlogknop
                        NavigationLink(destination: ContentView(), isActive: $isNavigate) {
                            Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.highlight)
                                .padding()
                                .onTapGesture {
                                    print("uitlogknop ingedrukt")
                                    tokenManager.removeToken()
                                    // Zet de state om naar true om te navigeren
                                    isNavigate = true
                                }
                        }
                    }
                    Spacer()
                }
                
                VStack {
                    Text("Welkom terug! \(catController.catModel.name) heeft op je gewacht!")
                        .padding()
                        .font(.title)
                        .background(.highlight)
                        .cornerRadius(15)
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                    //de status
                    BondStatusBarView(bondLevel: catController.catModel.bond)
                        .padding(.bottom, 30)
                    // de kat
                    CatView(catColor: catController.catModel.color, eyeColor: catController.catModel.eyeColor)
                        .padding(.top, 30)
                    // acties
                    HStack{
                        // kletsen
                        NavigationLink(destination: ChatView()){
                            Image(systemName: "paperplane.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.highlight)
                        }
                        
                        // Pennetje om te navigeren naar CustomizeCatView
                        NavigationLink(destination: CustomizeCatView()) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.highlight)
                        }
                        // todo's
                        NavigationLink(destination: TodoItemListView()) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.highlight)
                        }
                    }
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}
