import SwiftUI

struct AppTheme {
    struct Palette {
        static let lightBackground = Color(red: 0.97, green: 0.96, blue: 0.95)
        static let lightSurface = Color.white
        static let lightAccent = Color(red: 0.18, green: 0.56, blue: 0.51)
        static let lightText = Color(red: 0.07, green: 0.07, blue: 0.08)
        static let lightSecondary = Color(red: 0.42, green: 0.44, blue: 0.46)
        static let lightSeparator = Color(red: 0.91, green: 0.91, blue: 0.89)

        static let darkBackground = Color(red: 0.04, green: 0.05, blue: 0.05)
        static let darkSurface = Color(red: 0.08, green: 0.09, blue: 0.10)
        static let darkAccent = Color(red: 0.23, green: 0.71, blue: 0.65)
        static let darkText = Color(red: 0.96, green: 0.96, blue: 0.96)
        static let darkSecondary = Color(red: 0.65, green: 0.67, blue: 0.70)
        static let darkSeparator = Color(red: 0.14, green: 0.15, blue: 0.17)
    }

    static func background(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Palette.darkBackground : Palette.lightBackground
    }

    static func surface(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Palette.darkSurface : Palette.lightSurface
    }

    static func accent(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Palette.darkAccent : Palette.lightAccent
    }

    static func text(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Palette.darkText : Palette.lightText
    }

    static func secondary(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Palette.darkSecondary : Palette.lightSecondary
    }

    static func separator(_ scheme: ColorScheme) -> Color {
        scheme == .dark ? Palette.darkSeparator : Palette.lightSeparator
    }
}

struct CardStyle: ViewModifier {
    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppTheme.surface(scheme))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(scheme == .dark ? 0.25 : 0.06), radius: 12, x: 0, y: 6)
    }
}

extension View {
    func card() -> some View {
        modifier(CardStyle())
    }

    func pillChip(background: Color, foreground: Color) -> some View {
        self
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(background)
            .foregroundStyle(foreground)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
