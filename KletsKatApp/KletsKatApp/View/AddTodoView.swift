//
//  AddTodoView.swift
//  KletsKatApp
//
//  Created by Ruben Zwinkels on 29/10/2024.
//
import Foundation
import SwiftUI

struct AddTodoForm: View {
    @Binding var isPresented: Bool
    @ObservedObject var todoController: TodoController
    @State private var title: String = ""
    @State private var description: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nieuw Todo Item")) {
                    TextField("Titel", text: $title)
                    TextField("Beschrijving", text: $description)
                }
            }
            .navigationTitle("Nieuw Todo")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleer") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Opslaan") {
                        let newTodo = TodoItem(
                            title: title,
                            description: description,
                            creationDate: Date().formatted() // Voeg de huidige datum toe
                        )
                        todoController.addTodoItem(newTodo) { success in
                            if success {
                                print("Todo item succesvol toegevoegd.")
                                todoController.fetchTodoItems { success in
                                    if success {
                                        print("Todo items succesvol opgehaald.")
                                    } else {
                                        print("Fout bij het ophalen van todo items.")
                                    }
                                }
                            } else {
                                print("Fout bij het toevoegen van todo item.")
                            }
                        }
                        isPresented = false
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
