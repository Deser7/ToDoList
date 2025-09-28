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
        NavigationStack {
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
