import Foundation
import SwiftUI

class CatController: ObservableObject {
    static let shared = CatController()
    private let appGroupID = "group.RZwinkels.KletKatApp"
    
    private let apiUrl = "http://localhost:8080/api/cat"
    private var tokenManager = TokenManager()
    private let token: String
    
    @Published var catModel: CatModel {
        didSet {
            saveCatInStorage() // Automatisch opslaan in UserDefaults
        }
    }
    
    init() {
        if let token = tokenManager.getToken() {
            self.token = token
        } else {
            self.token = ""
        }
        
        // Ophalen van catModel vanuit UserDefaults, vervolgens wordt het vervangen door de API kat (dubbelop)
        self.catModel = CatController.loadCatFromStorage() ?? CatModel()
        
        //temp
        setLastOpenedDateTo(daysAgo: 14)

        // Start het initialisatieproces
        initializeCatData()
    }
    
    private func initializeCatData() {
        fetchCatData { success in
            if success {
                // pas de band alleen aan na een succesvolle API-aanroep
                self.updateCatBondAfterInactivePeriod()
            }
        }
    }

    
    func fetchCatData(completion: @escaping (Bool) -> Void) {
        performRequest(urlString: apiUrl, method: "GET") { success, error in
            if success {
                print("Katgegevens succesvol opgehaald.")
                completion(true)
            } else {
                print("Fout bij het ophalen van katgegevens: \(error ?? "")")
                completion(false)
            }
        }
    }
    func saveCat(color: Color, eyeColor: Color, name: String, personality: Personality, completion: @escaping (Bool, String?) -> Void) {
        let catStruct = CatStruct(
            color: CatController.colorToString(color),
            eyeColor: CatController.colorToString(eyeColor),
            name: name,
            bond: self.catModel.bond,
            personality: personality.rawValue
        )
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(catStruct)
            
            performRequest(urlString: apiUrl, method: "POST", body: jsonData) { success, error in
                if success {
                    print("Katgegevens opgeslagen")
                    // Werk het model bij
                    self.catModel.color = color
                    self.catModel.eyeColor = eyeColor
                    self.catModel.personality = personality
                    self.catModel.name = name
                    self.catModel.bond = 0
                    completion(true, nil)
                } else {
                    print("Fout bij het opslaan van katgegevens: \(error ?? "Onbekende fout")")
                    completion(false, error)
                }
            }
        } catch {
            print("Fout bij het encoderen van catStruct naar JSON: \(error.localizedDescription)")
            completion(false, "Fout bij het encoderen: \(error.localizedDescription)")
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
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON respons: \(jsonString)")
        } else {
            print("Kon data niet omzetten naar een string.")
        }

        do {
            let catStruct = try JSONDecoder().decode(CatStruct.self, from: data)

            let catColor = CatController.colorFromString(catStruct.color)
            let eyeColor = CatController.colorFromString(catStruct.eyeColor)

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
    
    // Opslaan van catModel in UserDefaults
    private func saveCatInStorage() {
        print("catcontroller - app: katgegevens opslaan in ud. katnaam: \(catModel.name)")
        let defaults = UserDefaults.standard
        defaults.set(catModel.name, forKey: "catName")
        defaults.set(CatController.colorToString(catModel.color), forKey: "catColor")
        defaults.set(CatController.colorToString(catModel.eyeColor), forKey: "catEyeColor")
        defaults.set(catModel.personality.rawValue, forKey: "catPersonality")
    }
    
    // Ophalen van catModel vanuit UserDefaults
    private static func loadCatFromStorage() -> CatModel? {
        let defaults = UserDefaults.standard
        guard let name = defaults.string(forKey: "catName"),
              let colorString = defaults.string(forKey: "catColor"),
              let eyeColorString = defaults.string(forKey: "catEyeColor"),
              let personalityRaw = defaults.string(forKey: "catPersonality"),
              let personality = Personality(from: personalityRaw) else {
            return nil
        }
        
        return CatModel(
            color: CatController.colorFromString(colorString),
            eyeColor: CatController.colorFromString(eyeColorString),
            name: name,
            bond: 0, // Hier kun je een default waarde gebruiken
            personality: personality
        )
    }
    
    public func increaseCatBond(amount: Int) {
        let original_bond = self.catModel.bond
        if original_bond + amount >= 100 {
            self.catModel.bond = 100
            return
        }
        if original_bond + amount <= 0 {
            self.catModel.bond = 0
            return
        }
        self.catModel.bond = original_bond + amount
    }
    
    private func updateCatBondAfterInactivePeriod() {
        let defaults = UserDefaults.standard
        let lastOpenedDate = defaults.object(forKey: "lastOpenedDate") as? Date ?? Date()
        let currentDate = Date()

        // Bereken het aantal dagen sinds de laatste keer dat de app werd geopend
        let daysSinceLastOpened = Calendar.current.dateComponents([.day], from: lastOpenedDate, to: currentDate).day ?? 0
        
        // Verminder de band met een factor afhankelijk van de dagen
        let calculatedReduction = daysSinceLastOpened * 2
        let bondReduction = min(calculatedReduction, catModel.bond) // Max afname is de huidige bond

        // Gebruik increaseCatBond met negatieve waarde om band te verminderen
        increaseCatBond(amount: -bondReduction)
        
        // Werk lastOpenedDate bij naar de huidige datum
        defaults.set(currentDate, forKey: "lastOpenedDate")
        
        // Debuggen en controleren van de nieuwe bondwaarde
        print("updateCatBondAfterInactivePeriod - lastOpened \(daysSinceLastOpened) dagen geleden, bondReduction: \(bondReduction), nieuwe bond: \(catModel.bond)")
    }

    // Statische methoden voor kleurconversie
    private static func colorFromString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
        case "orange": return .orange
        case "yellow": return .yellow
        case "white": return .white
        case "black": return .black
        case "gray": return .gray
        case "brown": return .brown
        default: return .clear
        }
    }
    
    private static func colorToString(_ color: Color) -> String {
        switch color {
        case .orange: return "orange"
        case .yellow: return "yellow"
        case .white: return "white"
        case .black: return "black"
        case .gray: return "gray"
        case .brown: return "brown"
        default: return "unknown"
        }
    }
    
    // voor testen
    func setLastOpenedDateTo(daysAgo: Int) {
        let defaults = UserDefaults.standard
        let testDate = Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        defaults.set(testDate, forKey: "lastOpenedDate")
        print("setLastOpenedDateTo: lastOpenedDate ingesteld op \(daysAgo) dagen geleden")
                
        print("laatste inlogdatum ingesteld op: \(daysAgo)")
    }
}
