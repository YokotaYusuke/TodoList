import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: ViewModel
    let inspection = Inspection<Self>()
    
    var body: some View {
        VStack {
            VStack {
                Text("TodoList")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                HStack {
                    TextField("todoを入力", text: $viewModel.draftTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button {
                        Task {
                            await viewModel.clickSaveButton()
                        }
                    } label: {
                        Text("save")
                    }
                    .padding(.trailing, 20)
                }
            }
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
        @Published var draftTodo = ""
        private var todoListRepository: TodoListRepository
        
        init(todoListRepository: TodoListRepository = DefaultTodoListRepository()) {
            self.todoListRepository = todoListRepository
            
            Task {
                await getTodos()
            }
        }
        
        func getTodos() async {
            do {
                let todos = try await todoListRepository.getTodos()
                DispatchQueue.main.async {
                    self.todos = todos
                }
            } catch {
                print("todosの取得に失敗しました")
            }
        }
        
        func clickSaveButton() async {
            do {
                let todos = try await todoListRepository.saveTodo(title: draftTodo)
                DispatchQueue.main.async {
                    self.todos = todos
                }
            } catch {
                print("todoの保存に失敗しました")
            }
        }
        
    }
}

#Preview {
    TodoListView(
        viewModel: .init(
            todoListRepository: DefaultTodoListRepository()
        )
    )
}
