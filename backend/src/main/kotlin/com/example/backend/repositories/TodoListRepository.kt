package com.example.backend.repositories

import com.example.backend.entity.TodoEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface TodoListRepository: JpaRepository<TodoEntity, UUID> {
}