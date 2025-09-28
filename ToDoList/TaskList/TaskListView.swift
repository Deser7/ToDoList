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
                        NavigationLink(destination: TaskDetailView(
                            title: task.title,
                            date: task.timestamp.dateStringWithSeparator,
                            details: task.details
                        )) {
                            TaskCellView(
                                title: task.title,
                                details: task.details,
                                timestamp: task.timestamp,
                                isCompleted: task.isCompleted,
                                onToggle: { toggleTask(task) }
                            )
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
            }
            .navigationTitle("Задачи")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func toggleTask(_ task: TaskItem) {
            withAnimation(.easeInOut(duration: 0.2)) {
                task.isCompleted.toggle()
            }
        }

    private func addItem() {
        withAnimation {
            let newItem = TaskItem(title: String())
            modelContext.insert(newItem)
        }
    }
    
    private func deleteTask(_ task: TaskItem) {
        withAnimation {
            modelContext.delete(task)
        }
    }

    private func deleteTasks(offsets: IndexSet) {
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
