import Nimble
import XCTest
import ViewInspector
@testable import TodoList


class TodoListViewTests: XCTestCase {
    @MainActor
    func test_todosをビューに表示する() throws {
        let stubTodoListRepository = StubTodoListRepository()
        let todos = [
            TodoList(id: UUID(), title: "hoge"),
            TodoList(id: UUID(), title: "fuga"),
        ]
        stubTodoListRepository.getTodos_returnValue = todos
                
        let view = TodoListView(viewModel: .init(todoListReposiotry: stubTodoListRepository))
        ViewHosting.host(view: view)
        
        wait(for: [view.inspection.inspect { view in
            let list = try view.find(ViewType.List.self)
            expect(try list.find(text: "hoge")).toNot(beNil())
            expect(try list.find(text: "fuga")).toNot(beNil())
        }])
    }
}

class TodoListViewModelTests: XCTestCase {
    func test_updateの中でTodoListRepositoryのgetTodosを呼ぶ() {
        let spyTodoListRepository = SpyTodoListRepository()
        
        _ =  TodoListView.ViewModel(todoListReposiotry: spyTodoListRepository)
        
        expect(spyTodoListRepository.getTodos_wasCalled).to(beTrue())
    }
    
    func test_getTodosの返り値をプロパティとして保持する() async {
        let stubTodoListRepository = StubTodoListRepository()
        let todos = [
            TodoList(id: UUID(), title: "hoge"),
            TodoList(id: UUID(), title: "fuga"),
        ]
        stubTodoListRepository.getTodos_returnValue = todos
        
        let viewModel = TodoListView.ViewModel(todoListReposiotry: stubTodoListRepository)
        
        expect(viewModel.todos.count).to(equal(2))
        expect(viewModel.todos).to(equal(todos))
    }
    

}


