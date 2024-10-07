import Nimble
import XCTest
@testable import TodoList

class TodoListRepositoryTests: XCTestCase {
    func test_getTodosを呼んだときhttpに正しいパスを渡して呼ぶ() async throws {
        let spyHttp = SpyHttp()
        
        let todoListRepository = DefaultTodoListRepository(http: spyHttp)
        _ = try await todoListRepository.getTodos()
        
        let url = URL(string: "/api/todos")!
        expect(spyHttp.data_argument_request).to(equal(URLRequest(url: url)))
    }
    
    func test_httpの返り値を返す() async throws {
        let todos = """
        [
            { "id": "11111111-1111-1111-1111-111111111111", "title": "hoge" },
            { "id": "22222222-2222-2222-2222-222222222222", "title": "fuga" },
        ]
        """
        let data = try XCTUnwrap(todos.data(using: .utf8))
        let stubHttp = StubHttp()
        stubHttp.data_returnValue = (data, URLResponse())
        let todoListRepository = DefaultTodoListRepository(http: stubHttp)
        
        let actualTodos = try await todoListRepository.getTodos()
        
        expect(actualTodos.first?.title).to(equal("hoge"))
        expect(actualTodos.last?.title).to(equal("fuga"))
    }
}
