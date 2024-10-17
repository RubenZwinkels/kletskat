//
//  ChatView.swift
//  KletsKatApp
//
//  Created by Ruben Zwinkels on 16/10/2024.
//

import SwiftUI
import OpenAI
import Foundation

struct ChatView: View {
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea() // achtergrond
            VStack {
                ScrollView {
                    ForEach(chatController.messages) {
                        message in
                        MessageView(message: message)
                            .padding(5)
                    }
                }
                Divider()
                HStack {
                    TextField("Message...", text: self.$string, axis: .vertical)
                        .padding(5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(15)
                    Button {
                        self.chatController.sendNewMessage(content: string)
                        string = ""
                    } label: {
                        Image(systemName: "paperplane.circle.fill")
                            .foregroundColor(.highlight)
                            .font(.system(size: 30))
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ChatView(string: "lorum ipsum")
}
