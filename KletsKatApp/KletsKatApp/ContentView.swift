import SwiftUI

struct ContentView: View {
    @ObservedObject var tokenManager = TokenManager()
    
    var body: some View {
        NavigationStack{
            VStack {
                //            Button("log uit"){
                //                tokenManager.removeToken()
                //            }
                if !tokenManager.isLoggedIn {
                    LoginSignupView(tokenManager: tokenManager)
                }
                if tokenManager.isLoggedIn{
                    HomeView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ContentView()
}
