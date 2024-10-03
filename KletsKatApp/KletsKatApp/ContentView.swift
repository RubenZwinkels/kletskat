import SwiftUI

struct ContentView: View {
    @ObservedObject var tokenManager = TokenManager()
    
    var body: some View {
        VStack {
            Button("log uit"){
                tokenManager.removeToken()
            }
            if !tokenManager.isLoggedIn {
                LoginSignupView(tokenManager: tokenManager)
            }
            if tokenManager.isLoggedIn{
                HomeView()
            }
        }
    }
}

#Preview {
    ContentView()
}
