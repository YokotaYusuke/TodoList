import TodoListPage from "./pages/TodoListPage";
import { DefaultTodoListRepository } from './repositories'

export default function App() {

  return (
    <TodoListPage todoListRepository={new DefaultTodoListRepository()}/>
  )
}