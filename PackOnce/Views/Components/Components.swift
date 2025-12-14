import SwiftUI

struct AccentButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(AppTheme.accent(scheme))
            .foregroundStyle(AppTheme.background(scheme))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

struct OutlineButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(AppTheme.surface(scheme))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.separator(scheme), lineWidth: 1)
            )
            .foregroundStyle(AppTheme.text(scheme))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct ProgressRing: View {
    var progress: Double
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.separator(scheme), lineWidth: 10)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppTheme.accent(scheme), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            Text("\(Int(progress * 100))%")
                .font(.headline)
                .foregroundStyle(AppTheme.text(scheme))
        }
        .frame(width: 84, height: 84)
    }
}
