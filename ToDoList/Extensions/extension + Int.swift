//
//  extension + Int.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 13.10.2025.
//

extension Int {
    var taskWord: String {
        let n = self % 100
        if n >= 11 && n <= 19 { return "задач" }
        switch n % 10 {
        case 1: return "задача"
        case 2, 3, 4: return "задачи"
        default: return "задач"
        }
    }
}
