//
//  TaskEditViewModelTests.swift
//  ToDoListTests
//
//  Created by Наташа Спиридонова on 01.10.2025.
//

import SwiftData
import Testing
@testable import ToDoList

@Suite("TaskEditViewModelTests")
struct TaskEditViewModelTests {
    
    // Инициализация без задачи и заголовок навигации
    @Test
    func initEmptyAndNavigationTitle() {
        let viewModel = TaskEditViewModel()
        #expect(viewModel.title == "")
        #expect(viewModel.details == "")
        #expect(viewModel.navigationTitle == "Новая задача")
    }
    
    // Инициализация с существующей задачей и заголовок навигации
    @Test
    func initWithTaskAndNavigationTitle() {
        let task = TaskItem(title: "T")
        task.details = "D"
        let viewModel = TaskEditViewModel(task: task)
        #expect(viewModel.id == task.id)
        #expect(viewModel.title == "T")
        #expect(viewModel.details == "D")
        #expect(viewModel.navigationTitle == "Редактировать задачу")
    }
    
    // Очистка текста (тримминг)
    @Test
    func createCleanTextTrims() {
        let viewModel = TaskEditViewModel()
        #expect(viewModel.createCleanText("  hello \n") == "hello")
        #expect(viewModel.createCleanText("\t demo  ") == "demo")
    }
    
    // Валидация заголовка
    @Test
    func isValidTitleVariants() {
        let viewModel = TaskEditViewModel()
        // невалидные
        #expect(viewModel.isValidTitle(" ") == false)
        #expect(viewModel.isValidTitle("\n\t ") == false)
        #expect(viewModel.isValidTitle("ab") == false)
        #expect(viewModel.isValidTitle("  ab ") == false)
        // валидные
        #expect(viewModel.isValidTitle("abc") == true)
        #expect(viewModel.isValidTitle("  abc ") == true)
    }
    
    // Сохранение: создаёт новую задачу из пустой VM
    @Test
    func saveCreates() throws {
        let context = try makeInMemoryContext()
        let viewModel = TaskEditViewModel()
        viewModel.title = " Задача "
        viewModel.details = " Детали "
        try viewModel.save(in: context)
        let items = try context.fetch(FetchDescriptor<TaskItem>())
        #expect(items.count == 1)
        #expect(items.first?.title == "Задача")
        #expect(items.first?.details == "Детали")
    }
    
    // Сохранение: обновляет существующую задачу
    @Test
    func saveUpdatesExistingItem() throws {
        let context = try makeInMemoryContext()
        
        let task = TaskItem(title: "Old")
        task.details = "OldD"
        context.insert(task)
        try context.save()
        
        let viewModel = TaskEditViewModel(task: task)
        viewModel.title = "  New "
        viewModel.details = " NewD  "
        try viewModel.save(in: context)
        
        let items = try context.fetch(FetchDescriptor<TaskItem>())
        #expect(items.count == 1)
        #expect(items.first?.title == "New")
        #expect(items.first?.details == "NewD")
    }
}
