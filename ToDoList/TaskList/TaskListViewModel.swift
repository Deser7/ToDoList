//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import Foundation
import Observation
import SwiftData

@Observable
final class TaskListViewModel {
    var searchText = ""
    var isLoading = false
    var hasLoadedInitialData = false
    
    func filteredTasks(_ tasks: [TaskItem]) -> [TaskItem] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return tasks
        }
        
        return tasks.filter { task in
            task.title.localizedCaseInsensitiveContains(searchText) ||
            task.details.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func getTaskStatistics(_ tasks: [TaskItem]) -> (total: Int, completed: Int, pending: Int) {
        let total = tasks.count
        let completed = tasks.filter { $0.isCompleted }.count
        let pending = total - completed
        return (total, completed, pending)
    }
    
    func loadInitialTasksIfNeeded(_ modelContext: ModelContext) async {
        guard !hasLoadedInitialData else { return }
        
        isLoading = true
        hasLoadedInitialData = true
        
        do {
            let apiTasks = try await NetworkManager.shared.loadTasks()
            
            apiTasks.forEach {
                let task = TaskItem(title: $0.todo)
                task.isCompleted = $0.completed
                modelContext.insert(task)
            }
            
            try modelContext.save()
            
        } catch {
            print("Ошибка загрузки задач: \(error.localizedDescription)")
            hasLoadedInitialData = false
        }
        
        isLoading = false
    }
}
