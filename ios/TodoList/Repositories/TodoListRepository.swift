import SwiftUI
import Foundation

protocol TodoListRepository {
    func getTodos() async throws -> [TodoList]
}

class DefaultTodoListRepository: TodoListRepository {
    var http: Http
    
    init(http: Http = URLSession.shared) {
        self.http = http
    }
    
    func getTodos() async throws -> [TodoList] {
        let url = URL(string: "http://localhost:8080/api/todos")!
        do {
            let (data, _) = try await http.data(for: URLRequest(url: url))
            let decoded = try JSONDecoder().decode([TodoList].self, from: data)
            return decoded
        } catch {
            return []
        }
    }
    
}
