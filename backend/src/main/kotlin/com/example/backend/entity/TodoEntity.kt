package com.example.backend.entity

import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "todos")
data class TodoEntity(
    @Id
    val id: UUID = UUID.randomUUID(),
    val title: String
)
