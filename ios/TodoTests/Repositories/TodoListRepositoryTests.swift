import Nimble
import XCTest
@testable import TodoList

class TodoListRepositoryTests: XCTestCase {
    let todos = """
        [
            { "id": "11111111-1111-1111-1111-111111111111", "title": "hoge" },
            { "id": "22222222-2222-2222-2222-222222222222", "title": "fuga" },
        ]
        """
    
    func test_getTodosを呼んだときhttpに正しいrequestを渡して呼ぶ() async throws {
        let spyHttp = SpyHttp()
        
        let todoListRepository = DefaultTodoListRepository(http: spyHttp)
        _ = try await todoListRepository.getTodos()
        
        let url = URL(string: "http://localhost:8080/api/todos")!
        expect(spyHttp.data_argument_request?.url).to(equal(url))
    }
    
    func test_httpの返り値を返す() async throws {
        let data = try XCTUnwrap(todos.data(using: .utf8))
        let stubHttp = StubHttp()
        stubHttp.data_returnValue = (data, URLResponse())
        let todoListRepository = DefaultTodoListRepository(http: stubHttp)
        
        let actualTodos = try await todoListRepository.getTodos()
        
        expect(actualTodos.count).to(equal(2))
        expect(actualTodos.first?.title).to(equal("hoge"))
        expect(actualTodos.last?.title).to(equal("fuga"))
    }
    
    func test_saveTodoを呼んだときhttpに正しいrequestを渡して呼ぶ() async throws {
        let spyHttp = SpyHttp()
        
        let todoListRepository = DefaultTodoListRepository(http: spyHttp)
        let title = "foo"
        _ = try await todoListRepository.saveTodo(title: title)
        let httpBody = title.data(using: .utf8)
        
        let url = URL(string: "http://localhost:8080/api/todos")!
        expect(spyHttp.data_argument_request?.url).to(equal(url))
        expect(spyHttp.data_argument_request?.httpMethod).to(equal("POST"))
        expect(spyHttp.data_argument_request?.value(forHTTPHeaderField: "Content-Type")).to(equal("application/json"))
        expect(spyHttp.data_argument_request?.httpBody).to(equal(httpBody))
    }
    
    func test_httpの戻り値を返す() async throws {
        let data = try XCTUnwrap(todos.data(using: .utf8))
        let stubHttp = StubHttp()
        stubHttp.data_returnValue = (data, URLResponse())
        let todoListRepository = DefaultTodoListRepository(http: stubHttp)
        
        let actualTodos = try await todoListRepository.saveTodo(title: "fuga")
        
        expect(actualTodos.count).to(equal(2))
        expect(actualTodos.first?.title).to(equal("hoge"))
        expect(actualTodos.last?.title).to(equal("fuga"))
    }
}
