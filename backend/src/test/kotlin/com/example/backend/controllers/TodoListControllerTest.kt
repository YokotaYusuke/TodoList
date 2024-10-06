package com.example.backend.controllers

import com.example.backend.entity.TodoEntity
import com.example.backend.services.TodoListService
import com.ninjasquad.springmockk.MockkBean
import io.mockk.every
import io.mockk.verify
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.get
import org.springframework.test.web.servlet.post

@WebMvcTest(TodoListController::class)
class TodoListControllerTest {
    @Autowired
    lateinit var mockMvc: MockMvc

    @MockkBean
    lateinit var spyStubTodoListService: TodoListService

    val todos = listOf(
        TodoEntity(title = "hoge"),
        TodoEntity(title = "fuga")
    )

    @Nested
    inner class GetTodos {
        @Test
        fun TodoListServiceのgetTodosを呼ぶ() {
            every { spyStubTodoListService.getTodos() } returns emptyList()

            mockMvc.get("/api/todos")
                .andExpect { status { isOk() } }

            verify { spyStubTodoListService.getTodos() }
        }

        @Test
        fun TodoListServiceのgetTodosの戻り値を返す() {
            every { spyStubTodoListService.getTodos() } returns todos

            val result = mockMvc.get("/api/todos")

            result
                .andExpect { jsonPath("$[0].title") { value("hoge") } }
                .andExpect { jsonPath("$[1].title") { value("fuga") } }
        }
    }

    @Nested
    inner class SaveTodo {
        @Test
        fun TodoListServiceのsaveTodoにtitleを渡して呼ぶ() {
            every { spyStubTodoListService.saveTodo(any()) } returns emptyList()

            mockMvc.post("/api/todos") {
                contentType = MediaType.APPLICATION_JSON
                content = "baz"
            }
                .andExpect { status { isCreated() } }

            verify { spyStubTodoListService.saveTodo("baz") }
        }

        @Test
        fun TodoListServiceのsaveTodoの戻り値を返す() {
            every { spyStubTodoListService.saveTodo(any()) } returns todos

            val result = mockMvc.post("/api/todos") {
                contentType = MediaType.APPLICATION_JSON
                content = "fuga"
            }

            result
                .andExpect { jsonPath("$[0].title") { value("hoge") } }
                .andExpect { jsonPath("$[1].title") { value("fuga") } }
        }
    }
}