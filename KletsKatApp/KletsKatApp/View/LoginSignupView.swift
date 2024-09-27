import SwiftUI

struct LoginSignupView: View {
    @State private var animateGradient = false
    @State public var userMail: String = ""
    @State public var userPassWord: String = ""
    @State private var registrationSuccess: Bool = false
    @State private var errorMessage: String? = nil
    private var userController = UserController()
    
    var body: some View {
        ZStack {
            // Achtergrond
            LinearGradient(gradient: Gradient(colors: [
                animateGradient ? .primairy : .secondairy,
                animateGradient ? .highlight : .primairy
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
            VStack(spacing: 20) {
                Text("Login of maak een account")
                    .font(.title)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                // Toon foutmelding als deze bestaat
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mail")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    TextField("Mail is verplicht", text: $userMail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Wachtwoord")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    SecureField("Wachtwoord is verplicht", text: $userPassWord)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                                
                HStack {
                    Button(action: {
                        // Actie voor de login-knop
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .background(.highlight)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding(.horizontal)
                    
                    Button(action: {
                        userController.registerUser(username: userMail, password: userPassWord) { success, error in
                            if success {
                                registrationSuccess = true
                                errorMessage = nil
                                print("Registratie geslaagd!")
                            } else {
                                registrationSuccess = false
                                errorMessage = error ?? "Onbekende fout."
                                print("Registratie mislukt: \(errorMessage ?? "")")
                            }
                        }
                    }) {
                        Text("Maak account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .background(.highlight)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoginSignupView()
}
