package com.example.backend.controllers

import com.example.backend.entity.TodoEntity
import com.example.backend.services.TodoListService
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*

@RestController
class TodoListController(
    private val todoListService: TodoListService
) {
    @GetMapping("/api/todos")
    fun getTodos() : List<TodoEntity> {
        return todoListService.getTodos()
    }

    @PostMapping("/api/todos")
    @ResponseStatus(HttpStatus.CREATED)
    fun saveTodo(@RequestBody title: String) : List<TodoEntity> {
        return todoListService.saveTodo(title)
    }
}