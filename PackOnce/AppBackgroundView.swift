import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.Colors.backgroundTop, AppTheme.Colors.backgroundBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [.clear, Color.black.opacity(0.6)],
                center: .center,
                startRadius: 120,
                endRadius: 520
            )
            .blendMode(.multiply)
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AppBackgroundView()
}
