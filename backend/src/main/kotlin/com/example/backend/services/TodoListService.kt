package com.example.backend.services

import com.example.backend.entity.TodoEntity
import com.example.backend.repositories.TodoListRepository
import org.springframework.stereotype.Service

interface TodoListService {
    fun getTodos(): List<TodoEntity>
    fun saveTodo(title: String): List<TodoEntity>
}

@Service
class DefaultTodoListService(
    private val todoListRepository: TodoListRepository
): TodoListService {
    override fun getTodos(): List<TodoEntity> {
        return todoListRepository.findAll()
    }

    override fun saveTodo(title: String): List<TodoEntity> {
        val todoEntity = TodoEntity(title = title)
        todoListRepository.save(todoEntity)
        return todoListRepository.findAll()
    }
}