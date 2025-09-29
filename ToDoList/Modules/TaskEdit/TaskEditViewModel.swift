//
//  TaskEditViewModel.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 29.09.2025.
//

import Foundation
import Observation
import SwiftData

@Observable
final class TaskEditViewModel: Identifiable {
    let id: UUID
    var title: String
    var details: String
    
    init(task: TaskItem) {
        self.id = task.id
        self.title = task.title
        self.details = task.details
    }
    
    func save(in context: ModelContext) throws {
        let descriptor = FetchDescriptor<TaskItem>(
            predicate: #Predicate { $0.id == id }
        )
        guard let item = try context.fetch(descriptor).first else { return }
        item.title = title
        item.details = details
        try context.save()
    }
    
    func isValidTitle(_ text: String) -> Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).count > 2
    }
}
