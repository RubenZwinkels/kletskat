import Foundation

class TokenManager: ObservableObject {
    let tokenKey = "authToken"
    
    @Published var isLoggedIn: Bool = true
    
    init() {
        if getToken() == nil {
            self.isLoggedIn = false
            print("isloggedin: \(self.isLoggedIn)")
        } else {
            self.isLoggedIn = true
            print("isloggedin: \(self.isLoggedIn)")
        }
    }
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        self.isLoggedIn = true
        print("isloggedin: \(self.isLoggedIn)")
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func removeToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        self.isLoggedIn = false
        print("isloggedin: \(self.isLoggedIn)")
    }
}
