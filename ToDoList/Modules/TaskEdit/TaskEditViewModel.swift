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
    private var task: TaskItem?
    
    let id: UUID
    var title: String
    var details: String
    
    var navigationTitle: String {
        task == nil ? "Новая задача" : "Редактировать задачу"
    }
    
    init(task: TaskItem) {
        self.task = task
        self.id = task.id
        self.title = task.title
        self.details = task.details
    }
    
    init() {
        self.task = nil
        self.id = UUID()
        self.title = ""
        self.details = ""
    }
    
    func save(in context: ModelContext) throws {
        if let task {
            task.title = createCleanText(title)
            task.details = createCleanText(details)
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
