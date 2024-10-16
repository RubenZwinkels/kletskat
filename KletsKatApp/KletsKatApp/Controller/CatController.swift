import Foundation
import SwiftUI
import SwiftData

class CatController: ObservableObject {
    static let shared = CatController()
    
    private let apiUrl = "http://localhost:8080/api/cat"
    private var tokenManager = TokenManager()
    private let token: String
    
    @Published var catModel: CatModel
    
    init() {
        if let token = tokenManager.getToken() {
            self.token = token
        } else {
            self.token = ""
        }
        catModel = CatModel()
        fetchCatData()
    }
    
    func fetchCatData() {
        performRequest(urlString: apiUrl, method: "GET") { success, error in
            if success {
                print("Katgegevens succesvol opgehaald.")
            } else {
                print("Fout bij het ophalen van katgegevens: \(error ?? "")")
            }
        }
    }
    
    func saveCat(color: Color, eyeColor: Color, name: String, personality: Personality, completion: @escaping (Bool, String?) -> Void) {
        // Maak de body aan
        let catStruct = CatStruct(
            color: colorToString(color),
            eyeColor: colorToString(eyeColor),
            name: name,
            bond: self.catModel.bond,
            personality: personality.rawValue
        )
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(catStruct)
            
            // Voer de request uit
            performRequest(urlString: apiUrl, method: "POST", body: jsonData) { success, error in
                if success {
                    print("Katgegevens opgeslagen")
                    // Werk het model bij
                    self.catModel.color = color
                    self.catModel.eyeColor = eyeColor
                    self.catModel.personality = personality
                    self.catModel.name = name
                    completion(true, nil) // Succes
                } else {
                    print("Fout bij het opslaan van katgegevens: \(error ?? "Onbekende fout")")
                    completion(false, error) // Geef de fout terug
                }
            }
        } catch {
            print("Fout bij het encoderen van catStruct naar JSON: \(error.localizedDescription)")
            completion(false, "Fout bij het encoderen: \(error.localizedDescription)") // Geef een fout terug
        }
    }
    
    private func performRequest(urlString: String, method: String, body: Data? = nil, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(false, "Ongeldige URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Stel de Content-Type in
        }

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, "Netwerkfout: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = data {
                self.handleResponse(data: data)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, "Geen geldige respons van de server")
                }
            }
        }
        task.resume()
    }
    
    private func handleResponse(data: Data) {
        // Print de ruwe JSON-data
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON respons: \(jsonString)")
        } else {
            print("Kon data niet omzetten naar een string.")
        }

        do {
            let catStruct = try JSONDecoder().decode(CatStruct.self, from: data)

            // Hier moet je de kleurstrings omzetten naar Color
            let catColor = colorFromString(catStruct.color)
            let eyeColor = colorFromString(catStruct.eyeColor)

            // Probeer de personality string om te zetten naar het Personality type
            guard let personality = Personality(from: catStruct.personality) else {
                print("Ongeldige personality waarde: \(catStruct.personality)")
                return
            }

            self.catModel = CatModel(
                color: catColor,
                eyeColor: eyeColor,
                name: catStruct.name,
                bond: catStruct.bond,
                personality: personality
            )
            print("Katgegevens succesvol opgehaald.")
        } catch {
            print("Fout bij het decoderen van respons: \(error.localizedDescription)")
        }
    }
    
 

    // functie om naam om te zetten naar kleur model
    private func colorFromString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
        case "orange":
            return .orange
        case "yellow":
            return .yellow
        case "white":
            return .white
        case "black":
            return .black
        case "gray":
            return .gray
        case "brown":
            return .brown
        default:
            return .clear
        }
    }
    private func colorToString(_ color: Color) -> String {
        switch color {
        case .orange:
            return "orange"
        case .yellow:
            return "yellow"
        case .white:
            return "white"
        case .black:
            return "black"
        case .gray:
            return "gray"
        case .brown:
            return "brown"
        default:
            return "unknown"
        }
    }
}
