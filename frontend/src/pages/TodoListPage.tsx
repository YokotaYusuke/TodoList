import { useEffect, useState } from 'react'
import TodoListRepository from '../repositories/TodoListRepository.ts'
import { TodoList } from '../models/TodoList.ts'

export default function TodoListPage(
  props: { todoListRepository: TodoListRepository }
) {
  const [todoLists, setTodoLists] = useState<TodoList[]>([])
  const [draftTodo, setDraftTodo] = useState('')

  useEffect(() => {
    getTodos()
  }, [])

  const getTodos = async () => {
    try {
      const todos = await props.todoListRepository.getTodos()
      setTodoLists(todos)
    } catch (error) {
      console.error(error)
    }
  }

  const saveButtonClick = async () => {
    const todos = await props.todoListRepository.saveTodo(draftTodo)
    setTodoLists(todos)
    setDraftTodo('')
  }

  const textInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setDraftTodo(event.target.value)
  }

  return (
    <>
      <input type="text" value={draftTodo} onChange={textInputChange}/>
      <button onClick={saveButtonClick}>Save</button>
      {todoLists.map((todoList) => (
        <div key={todoList.id}>
          {todoList.title}
        </div>
      ))}
    </>
  )
}