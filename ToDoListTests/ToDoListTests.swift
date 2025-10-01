//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import SwiftData
import Testing
@testable import ToDoList

func makeInMemoryContext() throws -> ModelContext {
    let schema = Schema([TaskItem.self])
    let conteiner = try ModelContainer(
        for: schema,
        configurations: .init(isStoredInMemoryOnly: true)
    )
    return ModelContext(conteiner)
}

struct ToDoListTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
}
