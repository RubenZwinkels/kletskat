import Foundation

class TodoController: ObservableObject {
    private let appGroupID = "group.RZwinkels.KletKatApp"
    private let apiUrl = "http://localhost:8080/api/todo"
    private var tokenManager = TokenManager()
    private let token: String
    @Published public var todoItems: [TodoItem] = []

    init(tokenManager: TokenManager = TokenManager()) {
        if let token = tokenManager.getToken() {
            self.token = token
        } else {
            self.token = ""
        }
        
        // Haal alle todo-items op bij initialisatie
        fetchTodoItems { success in
            if success {
                print("Todo-items succesvol opgehaald.")
            } else {
                print("Fout bij het ophalen van todo-items.")
            }
        }
    }

    func fetchTodoItems(completion: @escaping (Bool) -> Void) {
        performRequest(urlString: apiUrl, method: "GET") { success, error in
            if success {
                print("Todo-items succesvol opgehaald.")
                // Hier hoef je alleen true door te geven.
                completion(true)
            } else {
                print("Fout bij het ophalen van todo-items: \(error ?? "")")
                // Hier hoef je ook alleen false door te geven.
                completion(false)
            }
        }
    }
    
    func toggleTodoItem(id: UUID, completion: @escaping (Bool, String?) -> Void) {
        performRequest(urlString: apiUrl, method: "PUT", body: try? JSONEncoder().encode(id)) { success, error in
            if success {
                print("TodoItem met ID \(id) getoggeld.")
                completion(true, nil)
            } else {
                print("Fout bij het togglen van todo-item: \(error ?? "Onbekende fout")")
                completion(false, error)
            }
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
                // Print de JSON-respons
                print("Ontvangen data: \(String(data: data, encoding: .utf8) ?? "Onbekende data")")
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
        // Print de JSON-respons als een string
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON respons: \(jsonString)")
        } else {
            print("Kon data niet omzetten naar een string.")
        }

        // Probeer de respons te decoderen naar TodoItem
        do {
            let todoItems = try JSONDecoder().decode([TodoItem].self, from: data)
            print("Gedecodeerde TodoItems: \(todoItems)")
            self.todoItems = todoItems // Sla de opgehaalde todoItems op
        } catch {
            print("(todocontroller) Fout bij het decoderen van respons: \(error.localizedDescription)")
        }
    }
}
