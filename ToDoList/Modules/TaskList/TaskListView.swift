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
    
    @State private var listViewModel = TaskListViewModel()
    @State private var editViewModel: TaskEditViewModel? = nil
    @State private var showingAddTask = false
    @State private var selectedTask: TaskItem? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomSearchBarView(
                    text: $listViewModel.searchText,
                    onVoiceSearch: { print("Голосовой поиск нажат") }
                )
                
                if listViewModel.isLoading {
                    VStack {
                        ProgressView("Загрузка задач...")
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(listViewModel.filteredTasks(tasks)) { task in
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
                            .contextMenu {
                                Button {
                                    editViewModel = TaskEditViewModel(task: task)
                                } label: {
                                    Label("Редактировать", systemImage: "pencil")
                                }
                                
                                ShareLink(
                                    item: "\(task.title)\n\n\(task.details)\n\(task.timestamp.dateStringWithSeparator)"
                                ) {
                                    Label("Поделиться", systemImage: "square.and.arrow.up")
                                }
                                
                                Button(role: .destructive) {
                                    deleteTask(task)
                                    try? modelContext.save()
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
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
                await listViewModel.loadInitialTasksIfNeeded(modelContext)
            }
            .navigationDestination(item: $selectedTask) { task in
                TaskDetailView(
                    title: task.title,
                    date: task.timestamp.dateStringWithSeparator,
                    details: task.details
                )
            }
        }
        .overlay(alignment: .bottom) {
            AddTaskBarView(total: tasks.count) {
                editViewModel = TaskEditViewModel()
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .sheet(item: $editViewModel) { viewModel in
            TaskEditView(viewModel: viewModel)
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
            let current = listViewModel.filteredTasks(tasks)
            for index in offsets {
                guard current.indices.contains(index) else { continue }
                let task = current[index]
                modelContext.delete(task)
            }
            try? modelContext.save()
        }
    }
}

#Preview {
    TaskListView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
