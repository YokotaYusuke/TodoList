import SwiftUI

struct TodoList: Identifiable, Equatable, Decodable {
    let id: UUID
    let title: String
}
