import SwiftUI

struct TodoListResponse: Decodable {
    let id: UUID
    let title: String
}
