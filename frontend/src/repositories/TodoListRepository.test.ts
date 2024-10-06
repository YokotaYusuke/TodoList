import { afterAll, beforeEach, describe, expect, test, vi } from 'vitest'
import { DefaultTodoListRepository } from './TodoListRepository.ts'

describe('TodoListRepository', () => {
  let spyHttp: {
    get: ReturnType<typeof vi.fn>,
    post: ReturnType<typeof vi.fn>
  }

  const todos = [
    { id: '123', title: 'hoge' },
    { id: '456', title: 'fuga' },
  ]

  beforeEach(() => {
    spyHttp = {
      get: vi.fn().mockResolvedValue([]),
      post: vi.fn().mockResolvedValue([])
    }
  })

  afterAll(() => {
    vi.clearAllMocks()
  })

  describe('getAllTodos', () => {
    test('httpのgetにパスを渡して呼ぶ', () => {
      const todoListRepository = new DefaultTodoListRepository(spyHttp)

      todoListRepository.getTodos()

      expect(spyHttp.get).toHaveBeenCalledWith('/api/todos')
    })

    test('httpのgetの返り値を返す', async () => {
      spyHttp.get.mockResolvedValue(todos)
      const todoListRepository = new DefaultTodoListRepository(spyHttp)

      const actualTodos = await todoListRepository.getTodos()

      expect(actualTodos).toEqual(todos)
    })
  })

  describe('saveTodo', () => {
    test('httpのpostメソッドにパスとtitleを渡して呼ぶ', () => {
      const todoListRepository = new DefaultTodoListRepository(spyHttp)

      todoListRepository.saveTodo('hoge')

      expect(spyHttp.post).toHaveBeenCalledWith('/api/todos', 'hoge')
    })

    test('httpのpostメソッドの返り値を返す', async () => {
      spyHttp.post.mockResolvedValue(todos)
      const todoListRepository = new DefaultTodoListRepository(spyHttp)

      const actualTodos = await todoListRepository.saveTodo('hoge')

      expect(actualTodos).toEqual(todos)
    })
  })
})