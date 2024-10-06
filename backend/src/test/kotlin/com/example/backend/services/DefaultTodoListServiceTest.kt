package com.example.backend.services

import com.example.backend.entity.TodoEntity
import com.example.backend.repositories.TodoListRepository
import org.assertj.core.api.Assertions.assertThat
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest

@DataJpaTest
class DefaultTodoListServiceTest {
    @Autowired
    lateinit var todoListRepository: TodoListRepository

    lateinit var todoListService: TodoListService

    @BeforeEach
    fun setup() {
        todoListService = DefaultTodoListService(todoListRepository)
    }

    @Nested
    inner class GetTodos {
        @Test
        fun getTodosを呼ぶと保存されている全てのtodoを返す() {
            todoListRepository.deleteAll()
            val todos = listOf(
                TodoEntity(title = "hoge"),
                TodoEntity(title = "fuga"),
            )
            todoListRepository.saveAll(todos)

            val actualTodos = todoListService.getTodos()

            assertThat(actualTodos).hasSize(2)
            assertThat(actualTodos.first().title).isEqualTo(todos.first().title)
            assertThat(actualTodos.last().title).isEqualTo(todos.last().title)
        }

        @Test
        fun saveTodoを呼ぶとtodoを保存して全てのtodoを返す() {
            todoListRepository.save(TodoEntity(title = "hoge"))

            val actualTodos = todoListService.saveTodo("fuga")

            assertThat(actualTodos).hasSize(2)
            assertThat(actualTodos.first().title).isEqualTo("hoge")
            assertThat(actualTodos.last().title).isEqualTo("fuga")
        }
    }
}