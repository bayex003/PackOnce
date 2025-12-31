import Foundation
import SwiftData

@Model
final class Tag {
    var id: UUID
    var name: String

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

@Model
final class Template {
    var id: UUID
    var title: String
    var summary: String
    var category: String
    var icon: String
    var accent: String
    @Relationship(deleteRule: .cascade) var items: [TemplateItem]

    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        category: String,
        icon: String,
        accent: String,
        items: [TemplateItem] = []
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.category = category
        self.icon = icon
        self.accent = accent
        self.items = items
    }
}

@Model
final class TemplateItem {
    var id: UUID
    var name: String
    var quantity: Int
    var category: String
    var note: String
    var isPinned: Bool
    var isLastMinute: Bool
    @Relationship(inverse: \Template.items) var template: Template?

    init(
        id: UUID = UUID(),
        name: String,
        quantity: Int,
        category: String,
        note: String,
        isPinned: Bool,
        isLastMinute: Bool,
        template: Template? = nil
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.note = note
        self.isPinned = isPinned
        self.isLastMinute = isLastMinute
        self.template = template
    }
}

@Model
final class Pack {
    var id: UUID
    var name: String
    var createdAt: Date
    var tag: Tag?
    var subtitle: String
    var subtitleIcon: String
    var subtitleAccent: String
    var showProgressRing: Bool
    var isPinned: Bool
    var showsProgressBar: Bool
    var showsStatusLabel: Bool
    var template: Template?
    @Relationship(deleteRule: .cascade) var items: [PackItem]

    init(
        id: UUID = UUID(),
        name: String,
        createdAt: Date = Date(),
        tag: Tag? = nil,
        subtitle: String,
        subtitleIcon: String,
        subtitleAccent: String,
        showProgressRing: Bool,
        isPinned: Bool,
        showsProgressBar: Bool,
        showsStatusLabel: Bool,
        template: Template? = nil,
        items: [PackItem] = []
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.tag = tag
        self.subtitle = subtitle
        self.subtitleIcon = subtitleIcon
        self.subtitleAccent = subtitleAccent
        self.showProgressRing = showProgressRing
        self.isPinned = isPinned
        self.showsProgressBar = showsProgressBar
        self.showsStatusLabel = showsStatusLabel
        self.template = template
        self.items = items
    }

    var totalQuantity: Int {
        items.reduce(0) { $0 + max($1.quantity, 0) }
    }

    var packedQuantity: Int {
        items.reduce(0) { $0 + ($1.isPacked ? max($1.quantity, 0) : 0) }
    }

    var progress: Double {
        guard totalQuantity > 0 else { return 0 }
        return Double(packedQuantity) / Double(totalQuantity)
    }

    var tagName: String {
        tag?.name ?? "TRAVEL"
    }

    var lastMinuteAdds: Int? {
        let count = items.filter { $0.isLastMinute && !$0.isPacked }.count
        return count > 0 ? count : nil
    }
}

@Model
final class PackItem {
    var id: UUID
    var name: String
    var quantity: Int
    var category: String
    var note: String
    var isPacked: Bool
    var isPinned: Bool
    var isLastMinute: Bool
    var templateItem: TemplateItem?
    @Relationship(inverse: \Pack.items) var pack: Pack?

    init(
        id: UUID = UUID(),
        name: String,
        quantity: Int,
        category: String,
        note: String,
        isPacked: Bool,
        isPinned: Bool,
        isLastMinute: Bool,
        templateItem: TemplateItem? = nil,
        pack: Pack? = nil
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.note = note
        self.isPacked = isPacked
        self.isPinned = isPinned
        self.isLastMinute = isLastMinute
        self.templateItem = templateItem
        self.pack = pack
    }
}

enum ExportPreference: String, CaseIterable {
    case text = "Text"
    case pdf = "PDF"

    mutating func toggle() {
        self = self == .text ? .pdf : .text
    }
}
