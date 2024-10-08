@testable import TodoList

class SpyTodoListRepository: TodoListRepository {
    var getTodos_wasCalled: Bool = false
    func getTodos() async throws -> [TodoList] {
        getTodos_wasCalled = true
        return []
    }
    
    var saveTodo_argument_title: String? = nil
    func saveTodo(title: String) async throws -> [TodoList] {
        saveTodo_argument_title = title
        return []
    }
    
}

class StubTodoListRepository: TodoListRepository {
    var getTodos_returnValue: [TodoList] = []
    func getTodos() async throws -> [TodoList] {
        return getTodos_returnValue
    }
    
    var saveTodo_returnValue: [TodoList] = []
    func saveTodo(title: String) async throws -> [TodoList] {
        return saveTodo_returnValue
    }

}

class DummyTodoListRepository: TodoListRepository {
    func getTodos() async throws -> [TodoList] {
        return []
    }
    
    func saveTodo(title: String) async throws -> [TodoList] {
        return []
    }

}
