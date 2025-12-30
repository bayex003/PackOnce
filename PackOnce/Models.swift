import Foundation

struct Pack: Identifiable {
    let id = UUID()
    let name: String
    let itemCount: Int
    let completion: Double
    let tags: [String]
}

struct Template: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: String
}

struct PackItem: Identifiable {
    let id = UUID()
    let name: String
    let quantity: Int
    let isPacked: Bool
}

struct PackListEntry: Identifiable {
    let id = UUID()
    let name: String
    let tag: String
    let subtitle: String
    let subtitleIcon: String
    let subtitleAccent: String
    let packedCount: Int
    let totalCount: Int
    let progress: Double
    let showProgressRing: Bool
    let lastMinuteAdds: Int?
    let isPinned: Bool
    let showsProgressBar: Bool
    let showsStatusLabel: Bool
}

struct QuickStartTemplate: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let accent: String
}

enum SampleData {
    static let packs: [Pack] = [
        Pack(name: "Alpine Escape", itemCount: 18, completion: 0.72, tags: ["Hiking", "Cold"]),
        Pack(name: "Weekend Studio", itemCount: 12, completion: 0.4, tags: ["Creative", "Light"]),
        Pack(name: "Conference Kit", itemCount: 9, completion: 0.88, tags: ["Work", "Tech"])
    ]

    static let templates: [Template] = [
        Template(title: "Urban Explorer", description: "City-ready essentials for quick trips.", category: "City"),
        Template(title: "Trail Starter", description: "Base set for casual day hikes.", category: "Outdoors"),
        Template(title: "Cabin Reset", description: "Cozy getaway with layered outfits.", category: "Retreat")
    ]

    static let packItems: [PackItem] = [
        PackItem(name: "Insulated bottle", quantity: 1, isPacked: true),
        PackItem(name: "Merino base layer", quantity: 2, isPacked: false),
        PackItem(name: "Compact tripod", quantity: 1, isPacked: true)
    ]

    static let packListEntries: [PackListEntry] = [
        PackListEntry(
            name: "Tokyo Trip",
            tag: "TRAVEL",
            subtitle: "2 days left",
            subtitleIcon: "calendar",
            subtitleAccent: "muted",
            packedCount: 36,
            totalCount: 42,
            progress: 0.85,
            showProgressRing: true,
            lastMinuteAdds: nil,
            isPinned: false,
            showsProgressBar: false,
            showsStatusLabel: false
        ),
        PackListEntry(
            name: "Weekly Gym",
            tag: "FITNESS",
            subtitle: "Today, 6:00 PM",
            subtitleIcon: "clock.fill",
            subtitleAccent: "warning",
            packedCount: 0,
            totalCount: 12,
            progress: 0.0,
            showProgressRing: false,
            lastMinuteAdds: 1,
            isPinned: false,
            showsProgressBar: true,
            showsStatusLabel: false
        ),
        PackListEntry(
            name: "Baby Bag",
            tag: "FAMILY",
            subtitle: "Always Active",
            subtitleIcon: "arrow.triangle.2.circlepath",
            subtitleAccent: "muted",
            packedCount: 18,
            totalCount: 25,
            progress: 0.72,
            showProgressRing: false,
            lastMinuteAdds: 2,
            isPinned: false,
            showsProgressBar: true,
            showsStatusLabel: false
        ),
        PackListEntry(
            name: "Weekend Hike",
            tag: "OUTDOOR",
            subtitle: "Next Sunday",
            subtitleIcon: "calendar",
            subtitleAccent: "muted",
            packedCount: 0,
            totalCount: 0,
            progress: 0.0,
            showProgressRing: false,
            lastMinuteAdds: nil,
            isPinned: true,
            showsProgressBar: false,
            showsStatusLabel: true
        )
    ]

    static let quickStartTemplates: [QuickStartTemplate] = [
        QuickStartTemplate(title: "Gym", icon: "dumbbell.fill", accent: "orange"),
        QuickStartTemplate(title: "Trip", icon: "airplane", accent: "blue"),
        QuickStartTemplate(title: "Work", icon: "briefcase.fill", accent: "purple"),
        QuickStartTemplate(title: "Beach", icon: "sun.max.fill", accent: "teal")
    ]
}
