import Foundation
import Combine
import SwiftUI

class TodoController: ObservableObject {
    private let appGroupID = "group.RZwinkels.KletKatApp"
    private let apiUrl = "http://localhost:8080/api/todo"
    private var tokenManager = TokenManager()
    private let token: String
    @Published public var todoItems: [TodoItem] = []
    @ObservedObject var catController = CatController.shared

    init(tokenManager: TokenManager = TokenManager()) {
        if let token = tokenManager.getToken() {
            self.token = token
        } else {
            self.token = ""
        }
        
        fetchTodoItems { _ in }
    }
    
    // Functie om todo-items op te halen
    public func fetchTodoItems(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: apiUrl) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fout bij het ophalen van todo-items: \(error)")
                completion(false)
                return
            }
            
            guard let data = data else {
                completion(false)
                return
            }
            
            do {
                // Decodeer de JSON data naar TodoItem objecten
                let decoder = JSONDecoder()
                self.todoItems = try decoder.decode([TodoItem].self, from: data)
                print("Ontvangen data: \(self.todoItems)")
                completion(true)
            } catch {
                print("Fout bij het decoderen van respons: \(error)")
                completion(false)
            }
        }
        task.resume()
    }

    // Functie om een nieuw todo-item toe te voegen
    public func addTodoItem(_ item: TodoItem, completion: @escaping (Bool) -> Void) {
        var item2 = item
        item2.creationDate = nil
        
        guard let url = URL(string: apiUrl) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(item2)
            request.httpBody = jsonData
        } catch {
            print("Fout bij het encoderen van item id: \(item.id), \(error)")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fout bij het toevoegen van todo-item: \(error)")
                completion(false)
                return
            }
            DispatchQueue.main.async {
                self.todoItems.append(item) // Direct toevoegen aan de lijst
                completion(true)
            }

            
            completion(true)
            // niet update nvan de api, maar lokaal de todoitem toevoegen aan array
//            self.todoItems.append(item)
        }
        task.resume()
    }

    
    public func toggleTodoItem(_ id: UUID, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: apiUrl) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Verzend het UUID als een pure string zonder quotes of object.
        let idString = "\"\(id.uuidString)\" "
        request.httpBody = idString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fout bij het toggelen van todo-item: \(error)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // Update de lokale lijst van todo-items na het succesvol toggelen
                    if let index = self.todoItems.firstIndex(where: { $0.id == id }) {
                        self.todoItems[index].checked.toggle()
                    }
                    completion(true)
                } else {
                    print("Ongeldige responsstatus: \(httpResponse.statusCode)")
                    completion(false)
                }
            }
        }
        task.resume()
        catController.increaseCatBond(amount: 5)
    }
}
