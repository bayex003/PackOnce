import Foundation
import SwiftData

struct DataSeeder {
    static func seedIfNeeded(context: ModelContext) {
        let tagFetch = FetchDescriptor<Tag>()
        let templateFetch = FetchDescriptor<Template>()
        let packFetch = FetchDescriptor<Pack>()

        let hasTags = (try? context.fetch(tagFetch).isEmpty) == false
        let hasTemplates = (try? context.fetch(templateFetch).isEmpty) == false
        let hasPacks = (try? context.fetch(packFetch).isEmpty) == false

        if !hasTags {
            seedTags(in: context)
        }

        if !hasTemplates {
            seedTemplates(in: context)
        }

        if !hasPacks {
            seedPacks(in: context)
        }
    }

    private static func seedTags(in context: ModelContext) {
        let tags = ["TRAVEL", "FITNESS", "FAMILY", "OUTDOOR"].map { Tag(name: $0) }
        tags.forEach { context.insert($0) }
    }

    private static func seedTemplates(in context: ModelContext) {
        let templates = [
            Template(
                title: "Gym",
                summary: "Daily essentials for a quick training session.",
                category: "Fitness",
                icon: "dumbbell.fill",
                accent: "orange",
                items: [
                    TemplateItem(name: "Training shoes", quantity: 1, category: "Gear", note: "", isPinned: false, isLastMinute: false),
                    TemplateItem(name: "Water bottle", quantity: 1, category: "Gear", note: "", isPinned: false, isLastMinute: false),
                    TemplateItem(name: "Workout clothes", quantity: 1, category: "Clothes", note: "", isPinned: false, isLastMinute: false)
                ]
            ),
            Template(
                title: "Trip",
                summary: "Core travel checklist with essentials and layers.",
                category: "Travel",
                icon: "airplane",
                accent: "blue",
                items: tripTemplateItems()
            ),
            Template(
                title: "Work",
                summary: "Office-ready carry kit for busy days.",
                category: "Work",
                icon: "briefcase.fill",
                accent: "purple",
                items: [
                    TemplateItem(name: "Laptop", quantity: 1, category: "Tech", note: "", isPinned: true, isLastMinute: false),
                    TemplateItem(name: "Notebook", quantity: 1, category: "Essentials", note: "", isPinned: false, isLastMinute: false),
                    TemplateItem(name: "ID badge", quantity: 1, category: "Essentials", note: "", isPinned: true, isLastMinute: false)
                ]
            ),
            Template(
                title: "Beach",
                summary: "Sunny-day staples and quick sun protection.",
                category: "Leisure",
                icon: "sun.max.fill",
                accent: "teal",
                items: [
                    TemplateItem(name: "Swimsuit", quantity: 1, category: "Clothes", note: "", isPinned: false, isLastMinute: false),
                    TemplateItem(name: "Sunscreen", quantity: 1, category: "Toiletries", note: "", isPinned: false, isLastMinute: false),
                    TemplateItem(name: "Towel", quantity: 1, category: "Gear", note: "", isPinned: false, isLastMinute: false)
                ]
            )
        ]

        templates.forEach { template in
            template.items.forEach { $0.template = template }
            context.insert(template)
        }
    }

    private static func seedPacks(in context: ModelContext) {
        let tags = (try? context.fetch(FetchDescriptor<Tag>())) ?? []
        let templates = (try? context.fetch(FetchDescriptor<Template>())) ?? []

        let tagLookup = Dictionary(uniqueKeysWithValues: tags.map { ($0.name, $0) })
        let templateLookup = Dictionary(uniqueKeysWithValues: templates.map { ($0.title, $0) })

        let tokyoTrip = makePack(
            name: "Tokyo Trip",
            tag: tagLookup["TRAVEL"],
            subtitle: "2 days left",
            subtitleIcon: "calendar",
            subtitleAccent: "muted",
            showProgressRing: true,
            isPinned: false,
            showsProgressBar: false,
            showsStatusLabel: false,
            template: templateLookup["Trip"]
        )
        appendTripExtras(to: tokyoTrip)

        let weeklyGym = makePack(
            name: "Weekly Gym",
            tag: tagLookup["FITNESS"],
            subtitle: "Today, 6:00 PM",
            subtitleIcon: "clock.fill",
            subtitleAccent: "warning",
            showProgressRing: false,
            isPinned: false,
            showsProgressBar: true,
            showsStatusLabel: false,
            template: templateLookup["Gym"]
        )

        let babyBag = makePack(
            name: "Baby Bag",
            tag: tagLookup["FAMILY"],
            subtitle: "Always Active",
            subtitleIcon: "arrow.triangle.2.circlepath",
            subtitleAccent: "muted",
            showProgressRing: false,
            isPinned: false,
            showsProgressBar: true,
            showsStatusLabel: false,
            template: templateLookup["Trip"]
        )
        appendTripExtras(to: babyBag)

        let weekendHike = makePack(
            name: "Weekend Hike",
            tag: tagLookup["OUTDOOR"],
            subtitle: "Next Sunday",
            subtitleIcon: "calendar",
            subtitleAccent: "muted",
            showProgressRing: false,
            isPinned: true,
            showsProgressBar: false,
            showsStatusLabel: true,
            template: templateLookup["Trip"]
        )

        [tokyoTrip, weeklyGym, babyBag, weekendHike].forEach { context.insert($0) }
    }

    private static func tripTemplateItems() -> [TemplateItem] {
        [
            TemplateItem(
                name: "Passport",
                quantity: 1,
                category: "Essentials",
                note: "In top drawer",
                isPinned: true,
                isLastMinute: false
            ),
            TemplateItem(
                name: "Charger & Adapter",
                quantity: 1,
                category: "Essentials",
                note: "",
                isPinned: true,
                isLastMinute: false
            ),
            TemplateItem(
                name: "T-Shirts",
                quantity: 5,
                category: "Clothes",
                note: "",
                isPinned: false,
                isLastMinute: false
            ),
            TemplateItem(
                name: "Socks",
                quantity: 7,
                category: "Clothes",
                note: "",
                isPinned: false,
                isLastMinute: false
            )
        ]
    }

    private static func makePack(
        name: String,
        tag: Tag?,
        subtitle: String,
        subtitleIcon: String,
        subtitleAccent: String,
        showProgressRing: Bool,
        isPinned: Bool,
        showsProgressBar: Bool,
        showsStatusLabel: Bool,
        template: Template?
    ) -> Pack {
        let pack = Pack(
            name: name,
            tag: tag,
            subtitle: subtitle,
            subtitleIcon: subtitleIcon,
            subtitleAccent: subtitleAccent,
            showProgressRing: showProgressRing,
            isPinned: isPinned,
            showsProgressBar: showsProgressBar,
            showsStatusLabel: showsStatusLabel,
            template: template
        )

        if let template {
            let copiedItems = template.items.map { templateItem in
                PackItem(
                    name: templateItem.name,
                    quantity: templateItem.quantity,
                    category: templateItem.category,
                    note: templateItem.note,
                    isPacked: false,
                    isPinned: templateItem.isPinned,
                    isLastMinute: templateItem.isLastMinute,
                    templateItem: templateItem,
                    pack: pack
                )
            }
            pack.items.append(contentsOf: copiedItems)
        }

        return pack
    }

    private static func appendTripExtras(to pack: Pack) {
        let extras: [PackItem] = [
            PackItem(name: "Toothbrush", quantity: 1, category: "Toiletries", note: "Still wet, pack last", isPacked: false, isPinned: false, isLastMinute: true, pack: pack),
            PackItem(name: "Swimwear", quantity: 2, category: "Clothes", note: "", isPacked: false, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Sunscreen", quantity: 1, category: "Toiletries", note: "", isPacked: true, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Razor", quantity: 1, category: "Toiletries", note: "", isPacked: true, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Skincare kit", quantity: 1, category: "Toiletries", note: "", isPacked: false, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Camera", quantity: 2, category: "Tech", note: "Charge battery", isPacked: true, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Earbuds", quantity: 2, category: "Tech", note: "", isPacked: false, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Power bank", quantity: 2, category: "Tech", note: "", isPacked: false, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "E-reader", quantity: 2, category: "Tech", note: "", isPacked: true, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Travel journal", quantity: 2, category: "Extras", note: "", isPacked: true, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Reusable bag", quantity: 3, category: "Extras", note: "", isPacked: true, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Snacks", quantity: 4, category: "Extras", note: "Flight friendly", isPacked: false, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Compact umbrella", quantity: 2, category: "Extras", note: "", isPacked: true, isPinned: false, isLastMinute: false, pack: pack),
            PackItem(name: "Guidebook", quantity: 3, category: "Extras", note: "", isPacked: false, isPinned: false, isLastMinute: false, pack: pack)
        ]

        pack.items.append(contentsOf: extras)
    }
}
