import SwiftUI

struct TodoItemView: View {
    @ObservedObject var todoController: TodoController = TodoController()
    var todoItem: TodoItem

    // @State voor het bijhouden van de toggle-status en laadstatus
    @State private var isChecked: Bool
    @State private var isLoading: Bool = false // Voor het bijhouden van de laadstatus
    
    init(todoController: TodoController, todoItem: TodoItem) {
        self.todoController = todoController
        self.todoItem = todoItem
        _isChecked = State(initialValue: todoItem.checked)
    }

    var body: some View {
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
                    .strikethrough(isChecked, color: .black)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .padding()
            
            // Laadindicator tonen als isLoading waar is
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .frame(width: 20, height: 20) // Pas de grootte aan zoals nodig
            }
        }
    }
}
