import Foundation
import SwiftData

@Model
final class TemplateModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var typeTag: TypeTag
    var isPremium: Bool
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var items: [TemplateItemModel]

    init(id: UUID = UUID(), name: String, typeTag: TypeTag, isPremium: Bool = false, createdAt: Date = .now, items: [TemplateItemModel] = []) {
        self.id = id
        self.name = name
        self.typeTag = typeTag
        self.isPremium = isPremium
        self.createdAt = createdAt
        self.items = items
    }
}

@Model
final class TemplateItemModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var note: String
    var quantity: Int
    var category: String
    var isEssential: Bool

    init(id: UUID = UUID(), title: String, note: String = "", quantity: Int = 1, category: String = "General", isEssential: Bool = false) {
        self.id = id
        self.title = title
        self.note = note
        self.quantity = quantity
        self.category = category
        self.isEssential = isEssential
    }
}
