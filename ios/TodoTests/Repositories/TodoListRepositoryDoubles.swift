@testable import TodoList

class SpyTodoListRepository: TodoListRepository {
    var getTodos_wasCalled: Bool = false
    func getTodos() async throws -> [TodoList] {
        getTodos_wasCalled = true
        return []
    }
    
}

class StubTodoListRepository: TodoListRepository {
    var getTodos_returnValue: [TodoList] = []
    func getTodos() async throws -> [TodoList] {
        return getTodos_returnValue
    }
    
}
