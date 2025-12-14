import Foundation
import SwiftData

enum SeedData {
    static func ensureSeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<TemplateModel>()
        if let count = try? context.fetchCount(descriptor), count > 0 {
            return
        }

        let weekend = TemplateModel(name: "Weekend Pack", typeTag: .travel, items: [
            TemplateItemModel(title: "Clothes", quantity: 4, category: "Wardrobe"),
            TemplateItemModel(title: "Toothbrush", quantity: 1, category: "Toiletries", isEssential: true),
            TemplateItemModel(title: "Snacks", quantity: 2, category: "Food")
        ])

        let workBag = TemplateModel(name: "Work Bag", typeTag: .work, items: [
            TemplateItemModel(title: "Laptop", quantity: 1, category: "Tech", isEssential: true),
            TemplateItemModel(title: "Notebook", quantity: 1, category: "Stationery"),
            TemplateItemModel(title: "Charger", quantity: 1, category: "Tech", isEssential: true)
        ])

        let baby = TemplateModel(name: "Baby Day Out", typeTag: .baby, items: [
            TemplateItemModel(title: "Diapers", quantity: 6, category: "Care", isEssential: true),
            TemplateItemModel(title: "Wipes", quantity: 1, category: "Care"),
            TemplateItemModel(title: "Change of clothes", quantity: 2, category: "Wardrobe")
        ])

        let gym = TemplateModel(name: "Gym Session", typeTag: .gym, items: [
            TemplateItemModel(title: "Shoes", quantity: 1, category: "Wardrobe", isEssential: true),
            TemplateItemModel(title: "Water bottle", quantity: 1, category: "Hydration", isEssential: true),
            TemplateItemModel(title: "Locker lock", quantity: 1, category: "Accessories")
        ])

        let premium = [
            TemplateModel(name: "Camping Essentials", typeTag: .travel, isPremium: true),
            TemplateModel(name: "Newborn Travel", typeTag: .baby, isPremium: true),
            TemplateModel(name: "Car Emergency Kit", typeTag: .emergency, isPremium: true)
        ]

        for template in [weekend, workBag, baby, gym] + premium {
            context.insert(template)
        }

        try? context.save()
    }
}
