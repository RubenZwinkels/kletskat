import SwiftUI
import OpenAI
import Foundation

class ChatController: ObservableObject {
    @Published var messages: [Message] = []
    let env = Env()
    let openAI: OpenAI
    @ObservedObject var catController = CatController.shared

    init(){
        self.openAI = OpenAI(apiToken: env.apiToken)
    }
    
    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        self.messages.append(userMessage)
        getBotReply()
    }
    
    func getBotReply() {
        let backgroundPrompt: String = """
Jij bent een sprekende kat genaamd: \(catController.catModel.name). \
Jouw persoonlijkheid is: \(catController.catModel.personality). \
Zorg ervoor dat deze persoonlijkheid duidelijk is.
"""

        
        let query = ChatQuery(
            messages: [
                .init(role: .system, content: backgroundPrompt)!
            ] + self.messages.map({
                .init(role: .user, content: $0.content)!
            }),
            model: .gpt3_5Turbo
        )

        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                guard let message = choice.message.content?.string else { return }
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message, isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

struct Message: Identifiable {
    var id: UUID = .init()
    var content: String
    var isUser: Bool
}

