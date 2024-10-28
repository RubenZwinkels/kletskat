import SwiftUI

struct TodoItemsView: View {
    @StateObject private var todoController = TodoController() // Voeg de TodoController toe als StateObject
    
    var body: some View {
        VStack {
            Text("Todo Items")
                .font(.largeTitle)
                .padding()
            
            List(todoController.todoItems) { item in
                Text(item.title) // Pas aan om de title van je TodoItem weer te geven
            }
            .onAppear {
                // Haal de todo-items op wanneer de view verschijnt
                todoController.fetchTodoItems { success in
                    if success {
                        print("Todo-items succesvol opgehaald.")
                    } else {
                        print("Fout bij het ophalen van todo-items.")
                    }
                }
            }
        }
    }
}

#Preview {
    TodoItemsView()
}
