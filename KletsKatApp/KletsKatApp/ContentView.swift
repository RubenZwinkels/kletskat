import SwiftUI

struct ContentView: View {
    @ObservedObject var tokenManager = TokenManager()
    
    var body: some View {
        VStack {
            if !tokenManager.isLoggedIn {
                LoginSignupView(tokenManager: tokenManager)
            }
            if tokenManager.isLoggedIn{
                VStack {
                    Text("Welkom! Je bent ingelogd.")
                        .font(.title)
                        .padding()
                    
                    Button(action: {
                        tokenManager.removeToken()
                    }) {
                        Text("Uitloggen")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
