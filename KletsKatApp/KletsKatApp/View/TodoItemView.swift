import SwiftUI

struct TodoItemView: View {
    @ObservedObject var todoController: TodoController = TodoController()
    var todoItem: TodoItem

    // @State voor het bijhouden van de toggle-status en laadstatus
    @State private var isChecked: Bool
    @State private var isLoading: Bool = false // Voor het bijhouden van de laadstatus
    private var bigMode: Bool
    
    init(todoController: TodoController, todoItem: TodoItem, bigMode: Bool) {
        self.todoController = todoController
        self.todoItem = todoItem
        _isChecked = State(initialValue: todoItem.checked)
        self.bigMode = bigMode
    }

    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea() // achtergrond
            VStack {
                HStack {
                    Toggle(isOn: Binding<Bool>(
                        get: {
                            isChecked
                        },
                        set: { newValue in
                            isChecked = newValue // Lokaal bijwerken om de UI direct te updaten
                            isLoading = true // Begin met laden
                            
                            // Synchroniseer de wijziging met de backend
                            todoController.toggleTodoItem(todoItem.id) { success in
                                DispatchQueue.main.async {
                                    isLoading = false // Stop met laden
                                    if success {
                                        print("Todo item toggle succesvol")
                                    } else {
                                        print("Fout bij het togglen van todo item")
                                        // Reset de toggle naar de oorspronkelijke waarde bij een fout
                                        isChecked.toggle()
                                    }
                                }
                            }
                        }
                    )) {
                        Text(todoItem.title)
                            .font(.headline)
                            .strikethrough(isChecked, color: .black)
                            .foregroundColor(isChecked ? .gray : .primary)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .highlight))
                    .padding()
                    
                    // Laadindicator tonen als isLoading waar is
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .highlight))
                            .frame(width: 20, height: 20) // Pas de grootte aan zoals nodig
                    }
                }
                .padding()
                .background(Color(.primairy)) // Achtergrondkleur voor het item
                .cornerRadius(8) // Ronde hoeken
                .shadow(radius: 2) // Schaduw voor diepte
                
                // Wanneer de gebruiker erop klikt, tonen we extra informatie
                if bigMode {
                    VStack(alignment: .leading) {
                        Text("Beschrijving: \(todoItem.description)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top, 4)
                        
                        Text("Gemaakt op: \(todoItem.creationDate)")
                            .font(.footnote)
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .background(Color(.secondairy)) // Achtergrondkleur voor de beschrijving
                    .cornerRadius(8)
                    .shadow(radius: 1)
                }
            }
            .padding(.horizontal) // Padding voor de hele view
        }
    }
}

#Preview {
    TodoItemView(todoController: TodoController(), todoItem: TodoItem(title: "Titel", description: "Blablablablabla", creationDate: "2023-10-28"), bigMode: true)
}
