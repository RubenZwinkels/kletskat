import SwiftUI
import Foundation

struct CustomizeCatView: View {
    @ObservedObject var catController = CatController.shared
    @State private var catColor: Color = .orange
    @State private var eyeColor: Color = .black
    @State private var catName: String = "Simba"
    @State private var catPersonality: Personality = .happy
    @State private var isNavigate: Bool = false // state om terug te navigeren naar home
    @State private var errorMessage: String? // State voor foutmelding
    
    let availableCatColors: [Color] = [.orange, .yellow, .white, .black, .gray, .brown]
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea() // achtergrond
            VStack(spacing: 20) {
                TextField("Voer de naam van je kat in", text: $catName) // kat naam
                    .font(.largeTitle)
                    .padding()
                    .multilineTextAlignment(.center)
                    .background(.primairy.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Kat tonen
                CatView(catColor: catColor, eyeColor: eyeColor)
                    .padding(.bottom, 30)
                
                // Kat kleur kiezen
                VStack {
                    Text("Selecteer de kleur van je kat")
                        .font(.title2)
                        .padding(.top, 20)
                    HStack {
                        ForEach(availableCatColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 50, height: 50)
                                .onTapGesture { // Oogkleur omzetten
                                    catColor = color
                                    if color == .black {
                                        eyeColor = .gray // Ogen worden grijs bij zwarte kat
                                    } else {
                                        eyeColor = .black
                                    }
                                }
                                .overlay(
                                    Circle()
                                        .stroke(catColor == color ? Color.black : Color.clear, lineWidth: 3)
                                )
                        }
                    }
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 20) // achtergrondje voor selectbox
                        .fill(.primairy)
                )
                
                // persoonlijkheid kiezen
                Text("Selecteer de persoonlijkheid van je kat")
                    .font(.headline)
                    .padding(.bottom, 10)

                HStack {
                    ForEach(Personality.allCases, id: \.self) { personality in
                        Button(action: {
                            catPersonality = personality //persoonlijkheid instellen
                        }) {
                            Text(personality.rawValue.capitalized)
                                .font(.subheadline)
                                .padding()
                                .background(catPersonality == personality ? .primairy : Color.gray.opacity(0.8))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, 20)

                // Error message display
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                // opslaan knop
                Button(action: {
                    catController.saveCat(color: catColor, eyeColor: eyeColor, name: catName, personality: catPersonality) { success, error in
                        if success {
                            isNavigate = true // Navigeren naar HomeView
                            errorMessage = nil // Reset eventuele foutmelding
                        } else {
                            errorMessage = error ?? "Er is een onbekende fout opgetreden." // Toon foutmelding
                        }
                    }
                }) {
                    Text("Opslaan")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                }             .background(.highlight)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                .padding(.horizontal)
                .padding(.top, 30)

                // Navigatie
                NavigationLink(destination: HomeView(), isActive: $isNavigate) {
                    EmptyView()
                }
                .hidden() // Verberg de NavigationLink zelf
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
