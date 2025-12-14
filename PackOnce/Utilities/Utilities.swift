import Foundation
import SwiftUI

extension Collection where Element == PackItemModel {
    func packedProgress() -> Double {
        guard !isEmpty else { return 0 }
        let packed = filter { $0.isPacked }.count
        return Double(packed) / Double(count)
    }
}

extension PackModel {
    var completionPercentage: Double {
        items.packedProgress()
    }

    var categories: [String: [PackItemModel]] {
        Dictionary(grouping: items, by: { $0.category })
    }
}

struct SimpleHaptics {
    static func tap(enabled: Bool) {
#if canImport(UIKit)
        if enabled { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
#endif
    }
}
