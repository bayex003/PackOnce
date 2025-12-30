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
}
