import Foundation

class TokenManager {
    private let tokenKey = "authToken"
    private let tokenExpiryKey = "tokenExpiry"
    private let tokenLifetime: Int = 3600000
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(tokenLifetime)), forKey: tokenExpiryKey)
        print("Token opgeslagen: \(token)")
    }
    
    func retrieveToken() -> String? {
        let token = UserDefaults.standard.string(forKey: tokenKey)
        print("Opgehaalde token: \(token ?? "Geen token gevonden")")
        return token
    }
    
    func isTokenValid() -> Bool {
        guard let expiryDate = UserDefaults.standard.object(forKey: tokenExpiryKey) as? Date else {
            print("Geen vervaldatum gevonden.")
            return false
        }
        
        let isValid = Date() < expiryDate
        print("Is token geldig? \(isValid)")
        return isValid
    }
    
    func isLoggedIn() -> Bool {
        let loggedIn = retrieveToken() != nil && isTokenValid()
        print("Is gebruiker ingelogd? \(loggedIn)")
        return loggedIn
    }
}
