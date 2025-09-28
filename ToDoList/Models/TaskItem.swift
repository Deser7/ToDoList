//
//  Item.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import Foundation
import SwiftData

@Model
final class TaskItem {
    var id = UUID()
    var title: String
    var details = ""
    var timestamp = Date()
    var isCompleted = false
    
    init(title: String) {
        self.title = title
    }
}
