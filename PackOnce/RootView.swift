import SwiftUI
import SwiftData

enum TabRoute: String, CaseIterable {
    case packs = "Packs"
    case templates = "Templates"
    case settings = "Settings"

    var icon: String {
        switch self {
        case .packs: return "backpack"
        case .templates: return "square.stack.3d.up"
        case .settings: return "gearshape"
        }
    }
}

struct RootView: View {
    @State private var selectedTab: TabRoute = .packs
    @StateObject private var purchaseManager = PurchaseManager()
    @State private var exportPreference: ExportPreference = .pdf

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: 0) {
                ZStack {
                    switch selectedTab {
                    case .packs:
                        PacksView(
                            purchaseManager: purchaseManager,
                            exportPreference: $exportPreference
                        )
                    case .templates:
                        TemplatesPlaceholderView()
                    case .settings:
                        SettingsView(
                            purchaseManager: purchaseManager,
                            exportPreference: $exportPreference
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.bottom, AppTheme.Spacing.md)
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabRoute

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xl) {
            ForEach(TabRoute.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: AppTheme.Spacing.xs) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 18, weight: .semibold))
                        Text(tab.rawValue)
                            .font(AppTheme.Typography.caption())
                    }
                    .foregroundStyle(selectedTab == tab ? AppTheme.Colors.primary : AppTheme.Colors.textSecondary)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, AppTheme.Spacing.sm)
        .padding(.horizontal, AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                .fill(AppTheme.Colors.surfaceElevated.opacity(0.95))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
        )
        .applyShadow(AppTheme.Shadows.soft)
    }
}

#Preview {
    RootView()
        .modelContainer(for: [Pack.self, Template.self, TemplateItem.self, PackItem.self, Tag.self], inMemory: true)
}
