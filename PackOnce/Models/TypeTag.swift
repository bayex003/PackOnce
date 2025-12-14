import Foundation
import SwiftUI

enum TypeTag: String, CaseIterable, Codable, Identifiable {
    case travel = "Travel"
    case baby = "Baby"
    case gym = "Gym"
    case work = "Work"
    case home = "Home"
    case event = "Event"
    case emergency = "Emergency"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .travel: return "suitcase"
        case .baby: return "figure.and.child.holdinghands"
        case .gym: return "dumbbell"
        case .work: return "briefcase"
        case .home: return "house"
        case .event: return "calendar"
        case .emergency: return "cross.case"
        }
    }

    var tint: Color {
        switch self {
        case .travel: return .blue
        case .baby: return .pink
        case .gym: return .orange
        case .work: return .gray
        case .home: return .green
        case .event: return .purple
        case .emergency: return .red
        }
    }
}
