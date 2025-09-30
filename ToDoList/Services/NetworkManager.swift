//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    private init(session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 30
        return URLSession(configuration: configuration)
    }()) {
        self.session = session
    }
    
    func loadTasks() async throws -> [Response.ToDo] {
        guard let url = URL(string: API.url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.badStatus(http.statusCode)
        }
        
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            return response.todos
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
