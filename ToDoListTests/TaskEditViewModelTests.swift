//
//  TaskEditViewModelTests.swift
//  ToDoListTests
//
//  Created by Наташа Спиридонова on 01.10.2025.
//

import SwiftData
import Testing
@testable import ToDoList

@Suite("TaskEditViewModel")
struct Tests {

    @Test
    func isValidTitle() {
        let viewModel = TaskEditViewModel()
        #expect(viewModel.isValidTitle(" ") == false)
        #expect(viewModel.isValidTitle("ab") == false)
        #expect(viewModel.isValidTitle("abc") == true)
    }
    
    @Test
    func saveCreates() throws {
        let context = try makeInMemoryContext()
        let viewModel = TaskEditViewModel()
        viewModel.title = " Задача "; viewModel.details = " Детали "
        try viewModel.save(in: context)
        let items = try context.fetch(FetchDescriptor<TaskItem>())
        #expect(items.count == 1)
        #expect(items.first?.title == "Задача")
        #expect(items.first?.details == "Детали")
    }

}
