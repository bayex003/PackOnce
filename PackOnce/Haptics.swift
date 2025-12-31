import UIKit

enum Haptics {
    private static let enabledKey = "settings.hapticsEnabled"

    static var isEnabled: Bool {
        if let value = UserDefaults.standard.object(forKey: enabledKey) as? Bool {
            return value
        }
        return true
    }

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
