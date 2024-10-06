import { TodoList } from '../models/TodoList.ts'
import Http, { NetworkHttp } from '../http/NetworkHttp.ts'

export default interface TodoListRepository {
  getTodos(): Promise<TodoList[]>

  saveTodo(title: string): Promise<TodoList[]>
}

export class DefaultTodoListRepository implements TodoListRepository {
  http: Http

  constructor(http: Http = new NetworkHttp()) {
    this.http = http
  }

  getTodos(): Promise<TodoList[]> {
    return this.http.get('/api/todos')
  }

  saveTodo(title: string): Promise<TodoList[]> {
    return this.http.post('/api/todos', title)
  }
}

