//
//  TaskListViewModelLogicTests.swift
//  ToDoListTests
//
//  Created by Наташа Спиридонова on 01.10.2025.
//

import Foundation
import SwiftData
import Testing
@testable import ToDoList

@MainActor
@Suite("TaskListViewModelTests", .serialized)
struct TaskListViewModelTests {
    
    // Фильтрация задач
    @Test
    func filteredTasks() {
        let viewModel = TaskListViewModel()
        let taskOne = TaskItem(title: "Купить молоко"); taskOne.details = "2 литра"
        let taskTwo = TaskItem(title: "Позвонить маме"); taskTwo.details = "Вечером"
        let taskThree = TaskItem(title: "Сделать отчет"); taskThree.details = "По проекту"
        viewModel.searchText = "молоко"
        #expect(viewModel.filteredTasks([taskOne, taskTwo, taskThree]).map(\.title) == ["Купить молоко"])
        viewModel.searchText = "   "
        #expect(viewModel.filteredTasks([taskOne, taskTwo, taskThree]).count == 3)
    }
    
    // Загрузка при пустой базе данных
    @Test
    func loadsWhenDatabaseEmpty() async throws {
        let context = try makeInMemoryContext()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        let networkManager = NetworkManager(session: session)
        
        let url = URL(string: API.url)!
        URLProtocolStub.stub = .init(
            data: makeTodosJSON([
                ["todo": "First", "completed": true],
                ["todo": "Second", "completed": false]
            ]),
            response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil),
            error: nil
        )
        
        let existingTasksCount = try? context.fetchCount(FetchDescriptor<TaskItem>())
        guard existingTasksCount == 0 else {
            Issue.record("База данных должна быть пустой")
            return
        }
        
        let apiTasks = try await networkManager.loadTasks()
        
        apiTasks.forEach {
            let task = TaskItem(title: $0.todo)
            task.isCompleted = $0.completed
            task.details = "Подробная информация отсутствует. Загружено из сети."
            context.insert(task)
        }
        
        try context.save()
        
        let fetched = try context.fetch(FetchDescriptor<TaskItem>())
        #expect(fetched.count == 2, "Ожидалось 2 задачи, получено \(fetched.count)")
        
        let items = fetched.sorted { $0.title < $1.title }
        
        let first = items[0]
        #expect(first.title == "First", "Ожидалось 'First', получено '\(first.title)'")
        #expect(first.isCompleted == true)
        
        let second = items[1]
        #expect(second.title == "Second", "Ожидалось 'Second', получено '\(second.title)'")
        #expect(second.isCompleted == false)
        
        URLProtocolStub.stub = nil
    }
    
    // Пропуск загрузки при существующих данных
    @Test
    func skipsWhenDataExists() async throws {
        let viewModel = TaskListViewModel()
        let context = try makeInMemoryContext()
        
        let existing = TaskItem(title: "Existing")
        context.insert(existing)
        try context.save()
        
        await viewModel.loadInitialTasksIfNeeded(context)
        
        #expect(viewModel.hasLoadedInitialData == true)
        #expect(viewModel.isLoading == false)
        
        let items = try context.fetch(FetchDescriptor<TaskItem>())
        #expect(items.count == 1)
        #expect(items.first?.title == "Existing")
    }
}
