import SwiftUI

struct MessageView: View {
    var message: Message
    
    var body: some View {
        Group {
            if message.isUser {
                HStack {
                    Spacer()
                    Text(message.content)
                        .padding(15)
                        .background(.primairy)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .fixedSize(horizontal: false, vertical: true) // Laat de tekst over meerdere regels lopen
                }
                .padding(.horizontal)
            } else {
                HStack {
                    Text(message.content)
                        .padding(15)
                        .background(.secondairy)
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MessageView(message: Message(content: "Dit is een voorbeeld van een lange tekst die moet worden gesplitst in meerdere regels zonder afgekapt te worden door de vorm van de tekstbubbel.", isUser: true))
}
