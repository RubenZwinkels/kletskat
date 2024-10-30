import SwiftUI
import OpenAI
import Foundation

struct ChatView: View {
    @StateObject var chatController: ChatController = .init()
    @State private var string: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea() // achtergrond
                VStack {
                    ScrollView {
                        ForEach(chatController.messages) { message in
                            MessageView(message: message)
                                .padding(5)
                        }
                        Spacer()
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    
                    Divider()
                    
                    HStack {
                        TextField("Message...", text: self.$string, axis: .vertical)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                        
                        Button {
                            if !string.isEmpty {
                                self.chatController.sendNewMessage(content: string)
                                string = ""
                            }
                        } label: {
                            Image(systemName: "paperplane.circle.fill")
                                .foregroundColor(.highlight)
                                .font(.system(size: 30))
                        }
                    }
                    .padding()
                }
            }
            .navigationBarItems(
                leading: NavigationLink(destination: HomeView()) {
                    HStack {
                        Image(systemName: "arrow.backward.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                        Text("Home")
                            .foregroundColor(.blue)
                    }
                }
            )
            .navigationBarTitle("Chat", displayMode: .inline)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Functie om het toetsenbord te verbergen
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ChatView()
}
