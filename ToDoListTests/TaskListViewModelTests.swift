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
@Suite("TaskListViewModelTests")
struct TaskListViewModelTests {
    
    init() { URLProtocol.registerClass(URLProtocolStub.self) }
    
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
    
    @Test
    func loadsWhenDatabaseEmpty() async throws {
        let viewModel = TaskListViewModel()
        let context = try makeInMemoryContext()
        
        let url = URL(string: API.url)!
        URLProtocolStub.stub = .init(
            data: makeTodosJSON([
                ["todo": "Second", "completed": false],
                ["todo": "First",  "completed": true]
            ]),
            response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil),
            error: nil
        )
        
        await viewModel.loadInitialTasksIfNeeded(context)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.hasLoadedInitialData == true)
        
        let fetched = try context.fetch(FetchDescriptor<TaskItem>())
        let items = fetched.sorted { $0.title < $1.title }
        
        #expect(items.count == 2)
        
        let first  = items[0]
        #expect(first.title == "First")
        #expect(first.isCompleted == true)
        
        let second = items[1]
        #expect(second.title == "Second")
        #expect(second.isCompleted == false)
    }
    
    @Test
    func skipsWhenDataExists() async throws {
        let viewModel = TaskListViewModel()
        let context = try makeInMemoryContext()
        
        let existing = TaskItem(title: "Existing")
        context.insert(existing)
        try context.save()
        
        URLProtocolStub.stub = .init(data: nil, response: nil, error: URLError(.cannotFindHost))
        
        await viewModel.loadInitialTasksIfNeeded(context)
        
        #expect(viewModel.hasLoadedInitialData == true)
        #expect(viewModel.isLoading == false)
        
        let items = try context.fetch(FetchDescriptor<TaskItem>())
        #expect(items.count == 1)
        #expect(items.first?.title == "Existing")
    }
}
