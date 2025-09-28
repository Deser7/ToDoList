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
    @State private var selectedTask: TaskItem? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomSearchBarView(
                    text: $viewModel.searchText,
                    onVoiceSearch: { print("Голосовой поиск нажат") }
                )
                
                if viewModel.isLoading {
                    VStack {
                        ProgressView("Загрузка задач...")
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.filteredTasks(tasks)) { task in
                            TaskCellView(
                                title: task.title,
                                details: task.details,
                                timestamp: task.timestamp,
                                isCompleted: task.isCompleted,
                                onToggle: { toggleTask(task) }
                            )
                            .onTapGesture {
                                selectedTask = task
                            }
                        }
                        .onDelete(perform: deleteTasks)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Задачи")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await viewModel.loadInitialTasksIfNeeded(modelContext)
            }
            .navigationDestination(item: $selectedTask) { task in
                TaskDetailView(
                    title: task.title,
                    date: task.timestamp.dateStringWithSeparator,
                    details: task.details
                )
            }
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
