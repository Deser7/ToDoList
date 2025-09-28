//
//  ContentView.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import SwiftUI
import SwiftData

struct ToDoListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TaskItem]
    
    @State private var viewModel = ToDoListViewModel()
    @State private var showingAddTask = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(tasks) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = TaskItem(title: String())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tasks[index])
            }
        }
    }
}

#Preview {
    ToDoListView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
