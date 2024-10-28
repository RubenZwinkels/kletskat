import SwiftUI

struct TodoItemListView: View {
    @ObservedObject var todoController = TodoController()

    var body: some View {
        NavigationView {
            List(todoController.todoItems) { item in
                NavigationLink(destination: TodoItemView(todoItem: item)) {
                    TodoItemView(todoItem: item)
                }
            }
            .navigationTitle("Todo Items")
            .onAppear {
                todoController.fetchTodoItems { success in
                    if success {
                        print("Todo items succesvol opgehaald.")
                    } else {
                        print("Fout bij het ophalen van todo items.")
                    }
                }
            }
        }
    }
}
