import Foundation

struct UserController {
    let kkApiUrl: String = "http://localhost:8080/api"
    private let tokenManager = TokenManager()
    
    func performRequest(urlString: String, method: String, body: [String: Any]? = nil, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Ongeldige URL: \(urlString)")
            completion(false, "Ongeldige URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let body = body {
            do {
                let requestBody = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = requestBody
            } catch {
                print("Fout bij het encoderen van body: \(error.localizedDescription)")
                completion(false, "Fout bij het maken van de aanvraag")
                return
            }
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, "Netwerkfout: \(error.localizedDescription)")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("Response Status Code: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    completion(false, "Fout: \(httpResponse.statusCode)")
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
    
    func registerUser(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = "\(kkApiUrl)/auth/register"
        let body = ["email": username, "password": password]
        performRequest(urlString: url, method: "POST", body: body, completion: completion)
    }
    
    func handleResponse(data: Data) {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let token = jsonResponse["token"] as? String {
                tokenManager.saveToken(token)
            }
        } catch {
            print("Fout bij het decoderen van respons: \(error.localizedDescription)")
        }
    }
    
    func loginUser(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = "\(kkApiUrl)/auth/login"
        let body = ["email": username, "password": password]
        performRequest(urlString: url, method: "POST", body: body, completion: completion)
    }
}
