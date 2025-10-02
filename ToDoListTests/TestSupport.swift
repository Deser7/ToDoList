//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Наташа Спиридонова on 28.09.2025.
//

import Foundation
import SwiftData
@testable import ToDoList

final class URLProtocolStub: URLProtocol {
    struct Stub { let data: Data?; let response: URLResponse?; let error: Error? }
    static var stub: Stub?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let s = URLProtocolStub.stub else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse)); return
        }
        if let r = s.response {
            client?.urlProtocol(self, didReceive: r, cacheStoragePolicy: .notAllowed)
        }
        if let d = s.data {
            client?.urlProtocol(self, didLoad: d)
        }
        if let e = s.error {
            client?.urlProtocol(self, didFailWithError: e)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}

func makeTodosJSON(_ todos: [[String: Any]]) -> Data {
    try! JSONSerialization.data(withJSONObject: [
        "todos": todos,
        "total": todos.count,
        "skip": 0,
        "limit": 30
    ])
}

func makeInMemoryContext() throws -> ModelContext {
    let schema = Schema([TaskItem.self])
    let conteiner = try ModelContainer(
        for: schema,
        configurations: .init(isStoredInMemoryOnly: true)
    )
    return ModelContext(conteiner)
}
