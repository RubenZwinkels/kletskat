import Foundation

struct TodoItem: Codable, Identifiable {
    var id: UUID
    var title: String
    var description: String
    var checked: Bool
    var creationDate: String
}
