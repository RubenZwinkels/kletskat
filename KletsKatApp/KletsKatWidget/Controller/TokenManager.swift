//
//  TokenManager.swift
//  KletsKatApp
//
//  Created by Ruben Zwinkels on 17/10/2024.
//

import Foundation

class TokenManager: ObservableObject {
    let tokenKey = "authToken"
    
    @Published var isLoggedIn: Bool = true
    
    init() {
        if getToken() == nil {
            self.isLoggedIn = false
        } else {
            self.isLoggedIn = true
        }
    }
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
        self.isLoggedIn = true
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func removeToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        self.isLoggedIn = false
    }
}
