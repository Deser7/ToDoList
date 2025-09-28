//
//  ContentView.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [TaskItem]
    
    @State private var viewModel = TaskListViewModel()
    @State private var showingAddTask = false

    var body: some View {
        NavigationStack {
            VStack {
                CustomSearchBarView(
                    text: $viewModel.searchText,
                    onVoiceSearch: { print("Голосовой поиск нажат") }
                )
                
                List {
                    ForEach(viewModel.filteredTasks(tasks)) { task in
//                        NavigationLink(destination: TaskDetailView, label: <#T##() -> Label#>)
                    }
                }
            }
            .navigationTitle("Задачи")
            .navigationBarTitleDisplayMode(.large)
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
    TaskListView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
