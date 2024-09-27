//
//  UserController.swift
//  KletsKatApp
//
//  Created by Ruben Zwinkels on 23/09/2024.
//
import Foundation

struct UserController {
    let kkApiUrl: String = "http://localhost:8080/api"
    
    func performRequest(urlString: String, method: String, body: [String: Any]? = nil) {
        guard let url = URL(string: urlString) else {
            print("Ongeldige URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        print("Request URL: \(url)")
        print("Request Method: \(method)")
        
        if let body = body {
            do {
                let requestBody = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = requestBody
                print("Request Body: \(String(data: requestBody, encoding: .utf8) ?? "Body kon niet worden gelezen")")
            } catch {
                print("Fout bij het encoderen van body: \(error.localizedDescription)")
            }
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status Code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
            }
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print("Response Data: \(dataString ?? "Geen data ontvangen")")
            }
        }
        task.resume()
    }
    
    // Functie om een gebruiker te registreren
    func registerUser(email: String, password: String) {
        let url = "\(kkApiUrl)/auth/register"
        print("Attempting to register user at URL: \(url)")
        
        let body = ["email": email, "password": password]
        performRequest(urlString: url, method: "POST", body: body)
    }
}
