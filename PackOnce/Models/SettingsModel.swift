import Foundation
import SwiftData

@Model
final class SettingsModel {
    @Attribute(.unique) var id: UUID
    var moveCheckedToBottom: Bool
    var collapsePackedItems: Bool
    var enableHaptics: Bool
    var exportNotes: Bool
    var exportQuantities: Bool

    init(id: UUID = UUID(), moveCheckedToBottom: Bool = true, collapsePackedItems: Bool = true, enableHaptics: Bool = true, exportNotes: Bool = true, exportQuantities: Bool = true) {
        self.id = id
        self.moveCheckedToBottom = moveCheckedToBottom
        self.collapsePackedItems = collapsePackedItems
        self.enableHaptics = enableHaptics
        self.exportNotes = exportNotes
        self.exportQuantities = exportQuantities
    }
}
