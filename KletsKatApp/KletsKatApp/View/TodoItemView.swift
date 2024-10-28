import SwiftUI

struct TodoItemView: View {
    @ObservedObject var todoController: TodoController = TodoController()
    var todoItem: TodoItem

    var body: some View {
        HStack {
            Toggle(isOn: Binding<Bool>(
                get: {
                    todoItem.checked
                },
                set: { newValue in
                    todoController.toggleTodoItem(todoItem.id) { success in
                        if success {
                            print("Todo item toggle succesvol")
                        } else {
                            print("Fout bij het togglen van todo item")
                        }
                    }
                }
            )) {
                Text(todoItem.title)
                    .strikethrough(todoItem.checked, color: .black)
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
            .padding()
        }
    }
}
