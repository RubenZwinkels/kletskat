import SwiftUI

struct ContentView: View {
    @ObservedObject var tokenManager = TokenManager()
    @ObservedObject var catController = CatController.shared
    
    var body: some View {
        NavigationStack{
            VStack {
                if !tokenManager.isLoggedIn {
                    LoginSignupView(tokenManager: tokenManager)
                }
                if tokenManager.isLoggedIn{
                    if catController.catModel.name != "Unknown" {
                        HomeView()
                    } else {
                        CustomizeCatView()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView()
}
