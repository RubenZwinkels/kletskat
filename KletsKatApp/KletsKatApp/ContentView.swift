import SwiftUI

struct ContentView: View {
    @ObservedObject var tokenManager = TokenManager()
    
    var body: some View {
        VStack {
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
