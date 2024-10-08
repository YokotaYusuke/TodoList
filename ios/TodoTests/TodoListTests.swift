import Nimble
import XCTest
import ViewInspector
@testable import TodoList

let todos = [
    TodoList(id: UUID(), title: "hoge"),
    TodoList(id: UUID(), title: "fuga"),
]

class TodoListViewTests: XCTestCase {
    @MainActor
    func test_todosをビューに表示する() throws {
        let stubTodoListRepository = StubTodoListRepository()
        stubTodoListRepository.getTodos_returnValue = todos
        let view = TodoListView(viewModel: .init(todoListRepository: stubTodoListRepository))
        ViewHosting.host(view: view)
        
        wait(for: [view.inspection.inspect { view in
            let list = try view.find(ViewType.List.self)
            expect(try list.find(text: "hoge")).toNot(beNil())
            expect(try list.find(text: "fuga")).toNot(beNil())
        }])
    }
    
    @MainActor
    func test_todoを入力できるtextFieldとsaveButtonがある() throws {
        let dummyTodoListRepository = DummyTodoListRepository()
        let view = TodoListView(viewModel: .init(todoListRepository: dummyTodoListRepository))
        ViewHosting.host(view: view)
        
        wait(for: [view.inspection.inspect { view in
            let textField = try view.find(ViewType.TextField.self)
            let saveButton = try view.find(button: "save")
            expect(textField).toNot(beNil())
            expect(saveButton).toNot(beNil())
        }])
    }
    
}

class TodoListViewModelTests: XCTestCase {
    func test_updateの中でTodoListRepositoryのgetTodosを呼ぶ() {
        let spyTodoListRepository = SpyTodoListRepository()
        _ =  TodoListView.ViewModel(todoListRepository: spyTodoListRepository)
        
        expect(spyTodoListRepository.getTodos_wasCalled).to(beTrue())
    }
    
    func test_getTodosの返り値をviewModel内で保持する() async {
        let stubTodoListRepository = StubTodoListRepository()
        stubTodoListRepository.getTodos_returnValue = todos
        let viewModel = TodoListView.ViewModel(todoListRepository: stubTodoListRepository)
        
        expect(viewModel.todos.count).to(equal(2))
        expect(viewModel.todos).to(equal(todos))
    }
    
    func test_clickSaveButtonを実行するとsaveTodoにtitleを渡して呼ぶ() async throws {
        let spyTodoListRepository = SpyTodoListRepository()
        let viewModel = TodoListView.ViewModel(todoListRepository: spyTodoListRepository)
        viewModel.draftTodo = "hoge"
        
        await viewModel.clickSaveButton()
        
        expect(spyTodoListRepository.saveTodo_argument_title).to(equal("hoge"))
    }
    
    func test_saveTodoの返り値をviewModel内で保持する() async throws {
        let stubTodoListRepository = StubTodoListRepository()
        stubTodoListRepository.saveTodo_returnValue = todos
        let viewModel = TodoListView.ViewModel(todoListRepository: stubTodoListRepository)
        
        await viewModel.clickSaveButton()
        
        await expect(viewModel.todos.count).toEventually(equal(2))
        await expect(viewModel.todos).toEventually(equal(todos))
    }

}


