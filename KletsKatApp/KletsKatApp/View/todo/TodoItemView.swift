import SwiftUI

struct TodoItemView: View {
    @ObservedObject var todoController: TodoController = TodoController()
    var todoItem: TodoItem

    @State private var isChecked: Bool
    @State private var isLoading: Bool = false
    private var bigMode: Bool
    @Environment(\.presentationMode) var presentationMode // Voeg deze lijn toe

    init(todoController: TodoController, todoItem: TodoItem, bigMode: Bool) {
        self.todoController = todoController
        self.todoItem = todoItem
        _isChecked = State(initialValue: todoItem.checked)
        self.bigMode = bigMode
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                HStack {
                    Toggle(isOn: Binding<Bool>(
                        get: { isChecked },
                        set: { newValue in
                            isChecked = newValue
                            isLoading = true
                            
                            todoController.toggleTodoItem(todoItem.id) { success in
                                DispatchQueue.main.async {
                                    isLoading = false
                                    if success {
                                        print("Todo item toggle succesvol")
                                    } else {
                                        print("Fout bij het togglen van todo item")
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
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .highlight))
                            .frame(width: 20, height: 20)
                    }
                }
                .padding()
                .background(Color(.primairy))
                .cornerRadius(8)
                .shadow(radius: 2)
                
                if bigMode {
                    VStack(alignment: .leading) {
                        Text("Beschrijving: \(todoItem.description)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding(.top, 4)
                        
                        Text("Gemaakt op: \(todoItem.creationDate!)")
                            .font(.footnote)
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .background(Color(.secondairy))
                    .cornerRadius(8)
                    .shadow(radius: 1)
                    
                    Button(action: {
                        todoController.deleteTodoItem(todoItem.id) { success in
                            DispatchQueue.main.async { // hierdoor wordt dit process uitgevoerd op main thread (anders crasht het)
                                if success {
                                    presentationMode.wrappedValue.dismiss() // sluit de view
                                }
                            }
                        }
                    }) {
                        Label("Verwijder", systemImage: "trash.circle.fill")
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    TodoItemView(todoController: TodoController(), todoItem: TodoItem(title: "Titel", description: "Blablablablabla", creationDate: "2023-10-28"), bigMode: true)
}
