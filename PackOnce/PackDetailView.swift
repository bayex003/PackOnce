import SwiftUI

struct PackDetailView: View {
    let packName: String

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: AppTheme.Spacing.lg) {
                Text(packName)
                    .font(AppTheme.Typography.title())
                    .foregroundStyle(AppTheme.Colors.textPrimary)

                Text("Pack details coming in PR4.")
                    .font(AppTheme.Typography.body())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
            .padding(AppTheme.Spacing.xl)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PackDetailView(packName: "Tokyo Trip")
    }
}
