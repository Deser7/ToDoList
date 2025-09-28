//
//  API.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import Foundation

struct Response: Codable {
    let todos: [ToDo]
    let total: Int
    let skip: Int
    let limit: Int
    
    struct ToDo: Codable {
        let id: Int
        let todo: String
        let complete: Bool
        let userId: Int
    }
}
