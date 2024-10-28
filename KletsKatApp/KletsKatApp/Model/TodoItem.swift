import Foundation

struct TodoItem: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var checked: Bool
    var creationDate: String
    
    // Initializer om de UUID automatisch te genereren
    init(title: String, description: String, checked: Bool = false, creationDate: String = ISO8601DateFormatter().string(from: Date())) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.checked = checked
        self.creationDate = creationDate
    }
}
