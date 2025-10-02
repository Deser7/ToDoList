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
    
    func loadInitialTasksIfNeeded(_ modelContext: ModelContext) async {
        guard !hasLoadedInitialData else { return }
        
        let existingTasksCount = try? modelContext.fetchCount(FetchDescriptor<TaskItem>())
        guard existingTasksCount == 0 else {
            hasLoadedInitialData = true
            return
        }
        
        isLoading = true
        hasLoadedInitialData = true
        
        do {
            let apiTasks = try await NetworkManager.shared.loadTasks()
            
            apiTasks.forEach {
                let task = TaskItem(title: $0.todo)
                task.isCompleted = $0.completed
                task.details = "Подробная информация отсутствует. Загружено из сети."
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
