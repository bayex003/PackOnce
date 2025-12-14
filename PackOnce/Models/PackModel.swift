import Foundation
import SwiftData

@Model
final class PackModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var when: Date?
    var typeTag: TypeTag
    var pinned: Bool
    var lastOpened: Date
    var template: TemplateModel?
    @Relationship(deleteRule: .cascade) var items: [PackItemModel]

    init(id: UUID = UUID(), name: String, when: Date? = nil, typeTag: TypeTag, pinned: Bool = false, lastOpened: Date = .now, template: TemplateModel? = nil, items: [PackItemModel] = []) {
        self.id = id
        self.name = name
        self.when = when
        self.typeTag = typeTag
        self.pinned = pinned
        self.lastOpened = lastOpened
        self.template = template
        self.items = items
    }
}

@Model
final class PackItemModel {
    @Attribute(.unique) var id: UUID
    var title: String
    var note: String
    var quantity: Int
    var category: String
    var isPacked: Bool
    var isEssential: Bool
    var templateItem: TemplateItemModel?
    var addedAt: Date

    init(id: UUID = UUID(), title: String, note: String = "", quantity: Int = 1, category: String = "General", isPacked: Bool = false, isEssential: Bool = false, templateItem: TemplateItemModel? = nil, addedAt: Date = .now) {
        self.id = id
        self.title = title
        self.note = note
        self.quantity = quantity
        self.category = category
        self.isPacked = isPacked
        self.isEssential = isEssential
        self.templateItem = templateItem
        self.addedAt = addedAt
    }
}
