import SwiftUI

struct TodoListView: View {
    @StateObject var viewModel: ViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        VStack {
            Text("TodoList")
            List(viewModel.todos) { todo in
                Text(todo.title)
            }
        }
        .onReceive(inspection.notice) { self.inspection.visit(self, $0)}
    }
    
}

extension TodoListView {
    class ViewModel: ObservableObject {
        @Published var todos = [TodoList]()
        private var todoListRepository: TodoListRepository
        
        init(todoListReposiotry: TodoListRepository = DefaultTodoListRepository()) {
            self.todoListRepository = todoListReposiotry
            
            Task {
                do {
                    let todos = try await todoListReposiotry.getTodos()
                    DispatchQueue.main.async {
                        self.todos = todos
                    }
                } catch {
                    print("todosの取得に失敗しました")
                }
            }
        }
    }
}

#Preview {
    TodoListView(viewModel: .init(todoListReposiotry: DefaultTodoListRepository()))
}
