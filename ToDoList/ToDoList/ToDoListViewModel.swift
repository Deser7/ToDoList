//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import Foundation
import Observation

@Observable
final class ToDoListViewModel {
    var searchText = ""
    
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
}
