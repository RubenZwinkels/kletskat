import Foundation

class TokenManager: ObservableObject {
    private let tokenKey = "authToken"
    private let appGroupID = "group.RZwinkels.KletKatApp"
    
    @Published var isLoggedIn: Bool = true
    
    init() {
        if getToken() == nil {
            self.isLoggedIn = false
        } else {
            self.isLoggedIn = true
        }
    }
    
    func saveToken(_ token: String) {
        if let defaults = UserDefaults(suiteName: appGroupID) {
            defaults.set(token, forKey: tokenKey)
        }
        self.isLoggedIn = true
    }
    
    func getToken() -> String? {
        let defaults = UserDefaults(suiteName: appGroupID)
        return defaults?.string(forKey: tokenKey)
    }
    
    func removeToken() {
        if let defaults = UserDefaults(suiteName: appGroupID) {
            defaults.removeObject(forKey: tokenKey)
        }
        self.isLoggedIn = false
    }
}
