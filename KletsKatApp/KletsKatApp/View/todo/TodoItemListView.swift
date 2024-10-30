import SwiftUI

struct TodoItemListView: View {
    @ObservedObject var todoController = TodoController()
    @State private var isPresentingAddTodoForm = false
    @State private var newTodoTitle: String = ""
    @State private var newTodoDescription: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.background.ignoresSafeArea() // achtergrond
                List(todoController.todoItems) { item in
                    NavigationLink(destination: TodoItemView(todoController: todoController, todoItem: item, bigMode: true)) {
                        TodoItemView(todoController: todoController, todoItem: item, bigMode: false)
                    }
                    .listRowBackground(Color.background)
                }
                .listStyle(PlainListStyle())
                .background(Color.background)
                .navigationTitle("Todo Items")
                .toolbar {
                    // Toevoegen-knop in de navigatiebalk
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isPresentingAddTodoForm = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.highlight)
                        }
                    }
                }
                .sheet(isPresented: $isPresentingAddTodoForm) {
                    AddTodoForm(
                        isPresented: $isPresentingAddTodoForm,
                        todoController: todoController
                    )
                }
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
            .navigationBarItems(
                leading: NavigationLink(destination: HomeView()) {
                    HStack {
                        Image(systemName: "arrow.backward.circle.fill")
                            .foregroundColor(.highlight)
                            .font(.system(size: 20))
                        Text("Home")
                            .foregroundColor(.highlight)
                    }
                }
            )
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TodoItemListView()
}
