//
//  APIError.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL, invalidResponse, badStatus(Int), decoding(Error)
}
