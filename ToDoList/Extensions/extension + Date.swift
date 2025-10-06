//
//  extention + Date.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import Foundation

private enum DateFormatters {
    static let short: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
}

extension Date {
    var dateStringWithSeparator: String {
        DateFormatters.short.string(from: self)
    }
}

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
