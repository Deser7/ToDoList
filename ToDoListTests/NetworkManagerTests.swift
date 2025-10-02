//
//  NetworkManagerTests.swift
//  ToDoListTests
//
//  Created by Наташа Спиридонова on 02.10.2025.
//

import Foundation
import Testing
@testable import ToDoList

@MainActor
@Suite("NetworkManagerTests", .serialized)
struct NetworkManagerTests: ~Copyable {

    // Успех: статус 200, валидный JSON, две задачи в ответе
    @Test
    func loadTasksSuccess() async throws {
        URLCache.shared.removeAllCachedResponses()
        URLProtocolStub.stub = nil
        let url = URL(string: API.url)!
        URLProtocolStub.stub = .init(
            data: try! JSONSerialization.data(
                withJSONObject: [
                    "todos": [
                        ["todo": "First",  "completed": true],
                        ["todo": "Second", "completed": false]
                    ],
                    "total": 2,
                    "skip": 0,
                    "limit": 30
                ]
            ),
            response: HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        let sut = NetworkManager(session: session)
        let result = try await sut.loadTasks()
        let titlesAndFlags = await MainActor.run {
            result.map { ($0.todo, $0.completed) }
        }
        #expect(titlesAndFlags.count == 2)
        #expect(Set(titlesAndFlags.map { $0.0 }) == ["First","Second"])
        #expect(titlesAndFlags.contains(where: {
            $0.0 == "First" && $0.1 == true
        }))
        #expect(titlesAndFlags.contains(where: {
            $0.0 == "Second" && $0.1 == false
        }))

        URLProtocolStub.stub = nil
    }

    // Ошибка: статус 500 → ожидаем .badStatus(500)
    @Test
    func loadTasksBadStatus() async {
        URLCache.shared.removeAllCachedResponses()
        URLProtocolStub.stub = nil
        let url = URL(string: API.url)!
        URLProtocolStub.stub = .init(
            data: Data(),
            response: HTTPURLResponse(
                url: url,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        let sut = NetworkManager(session: session)
        do {
            _ = try await sut.loadTasks()
            Issue.record("Ожидалась ошибка badStatus")
        } catch let NetworkError.badStatus(code) {
            #expect(code == 500)
        } catch {
            Issue.record("Неверная ошибка: \(error)")
        }

        URLProtocolStub.stub = nil
    }

    // Ошибка декодирования: статус 200, но тело невалидное → .decoding
    @Test
    func loadTasksDecodingError() async {
        URLCache.shared.removeAllCachedResponses()
        URLProtocolStub.stub = nil
        let url = URL(string: API.url)!
        // намеренно невалидный JSON
        let badJSON = Data(#"{"todos": invalid"#.utf8)
        URLProtocolStub.stub = .init(
            data: badJSON,
            response: HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ),
            error: nil
        )

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        let sut = NetworkManager(session: session)
        do {
            _ = try await sut.loadTasks()
            Issue.record("Ожидалась ошибка decoding")
        } catch NetworkError.decoding(_) {
            // ok
        } catch {
            Issue.record("Неверная ошибка: \(error)")
        }

        URLProtocolStub.stub = nil
    }

    // Ошибка формата ответа: non-HTTP URLResponse → .invalidResponse
    @Test
    func loadTasksInvalidResponse() async {
        URLCache.shared.removeAllCachedResponses()
        URLProtocolStub.stub = nil
        let url = URL(string: API.url)!
        let nonHTTP = URLResponse(
            url: url,
            mimeType: "application/json",
            expectedContentLength: -1,
            textEncodingName: nil
        )
        URLProtocolStub.stub = .init(
            data: Data(),
            response: nonHTTP,
            error: nil
        )

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        let sut = NetworkManager(session: session)
        do {
            _ = try await sut.loadTasks()
            Issue.record("Ожидалась ошибка invalidResponse")
        } catch NetworkError.invalidResponse {
            // ok
        } catch {
            Issue.record("Неверная ошибка: \(error)")
        }

        URLProtocolStub.stub = nil
    }
}
