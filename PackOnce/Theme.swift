import SwiftUI

struct AppTheme {
    struct Colors {
        static let backgroundTop = Color(red: 0.08, green: 0.10, blue: 0.16)
        static let backgroundBottom = Color(red: 0.02, green: 0.03, blue: 0.06)
        static let surface = Color(red: 0.12, green: 0.14, blue: 0.20)
        static let surfaceElevated = Color(red: 0.16, green: 0.18, blue: 0.26)
        static let surfaceBorder = Color.white.opacity(0.12)
        static let primary = Color(red: 0.35, green: 0.90, blue: 0.92)
        static let primaryMuted = Color(red: 0.22, green: 0.60, blue: 0.62)
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.74)
        static let accent = Color(red: 0.48, green: 0.64, blue: 1.0)
        static let warning = Color(red: 1.0, green: 0.75, blue: 0.4)
    }

    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }

    struct Radii {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 18
        static let xl: CGFloat = 28
        static let pill: CGFloat = 999
    }

    struct ShadowStyle {
        let color: Color
        let radius: CGFloat
        let x: CGFloat
        let y: CGFloat
    }

    struct Shadows {
        static let soft = ShadowStyle(color: .black.opacity(0.22), radius: 16, x: 0, y: 10)
        static let subtle = ShadowStyle(color: .black.opacity(0.16), radius: 8, x: 0, y: 4)
        static let glow = ShadowStyle(color: Colors.primary.opacity(0.25), radius: 16, x: 0, y: 0)
    }

    struct Typography {
        static func title() -> Font { .system(size: 28, weight: .semibold, design: .rounded) }
        static func headline() -> Font { .system(size: 20, weight: .semibold, design: .rounded) }
        static func body() -> Font { .system(size: 16, weight: .regular, design: .rounded) }
        static func callout() -> Font { .system(size: 14, weight: .medium, design: .rounded) }
        static func caption() -> Font { .system(size: 12, weight: .medium, design: .rounded) }
    }
}

extension View {
    func applyShadow(_ style: AppTheme.ShadowStyle) -> some View {
        shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }
}
