import { afterAll, beforeEach, describe, expect, test, vi } from 'vitest'
import { act, render, screen } from '@testing-library/react'
import TodoListPage from './TodoListPage.tsx'
import '@testing-library/jest-dom'
import { userEvent } from '@testing-library/user-event'

describe('TodoListPage', () => {
  let spyStubTodoListRepository: {
    getTodos: ReturnType<typeof vi.fn>,
    saveTodo: ReturnType<typeof vi.fn>
  }

  beforeEach(() => {
    spyStubTodoListRepository = {
      getTodos: vi.fn().mockResolvedValue([]),
      saveTodo: vi.fn().mockResolvedValue([]),
    }
  })

  afterAll(() => {
    vi.clearAllMocks()
  })

  test('初期レンダリング時にTodoListRepositoryのgetTodosを呼ぶ', async () => {
    await act(async () => {
      render(<TodoListPage todoListRepository={spyStubTodoListRepository} />)
    })

    expect(spyStubTodoListRepository.getTodos).toHaveBeenCalled()
  })

  test('getTodosの返り値のtodosを表示する', async () => {
    spyStubTodoListRepository.getTodos.mockResolvedValue([
      { id: '123', title: 'hoge' },
      { id: '456', title: 'fuga' },
    ])

    await act(async () => {
      render(<TodoListPage todoListRepository={spyStubTodoListRepository} />)
    })

    expect(screen.getByText('hoge')).toBeInTheDocument()
    expect(screen.getByText('fuga')).toBeInTheDocument()
  })

  test('saveTodoの返り値のtodosを表示する', async () => {
    spyStubTodoListRepository.saveTodo.mockResolvedValue([
      { id: '123', title: 'hoge' },
      { id: '456', title: 'fuga' },
    ])
    await act(async () => {
      render(<TodoListPage todoListRepository={spyStubTodoListRepository} />)
    })

    await userEvent.type(screen.getByRole('textbox'), 'fuga')
    await userEvent.click(screen.getByRole('button', { name: 'Save' }))

    expect(spyStubTodoListRepository.saveTodo).toHaveBeenCalledWith('fuga')
    expect(screen.getByText('hoge'))
    expect(screen.getByText('fuga'))
  })

  test('todoを保存したらtextInputを空にする', async () => {
    await act(async () => {
      render(<TodoListPage todoListRepository={spyStubTodoListRepository} />)
    })

    await userEvent.type(screen.getByRole('textbox'), 'foo')
    await userEvent.click(screen.getByRole('button', { name: 'Save' }))

    const textbox = screen.getByRole('textbox') as HTMLInputElement
    expect(textbox.value).toEqual('')
  })

})