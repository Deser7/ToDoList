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
    let id: UUID?
    var title: String
    var details: String
    
    init(task: TaskItem) {
        self.id = task.id
        self.title = task.title
        self.details = task.details
    }
    
    init() {
        self.id = nil
        self.title = ""
        self.details = ""
    }
    
    func save(in context: ModelContext) throws {
        if let id {
            let descriptor = FetchDescriptor<TaskItem>(predicate: #Predicate { $0.id == id })
            guard let item = try context.fetch(descriptor).first else { return }
            item.title = createCleanText(title)
            item.details = createCleanText(details)
        } else {
            let item = TaskItem(title: createCleanText(title))
            item.details = createCleanText(details)
            context.insert(item)
        }
        try context.save()
    }
    
    func isValidTitle(_ text: String) -> Bool {
        createCleanText(text).count > 2
    }
    
    func createCleanText(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
