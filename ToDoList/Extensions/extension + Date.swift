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
