import SwiftUI

struct SettingsView: View {
    @ObservedObject var purchaseManager: PurchaseManager
    @Binding var exportPreference: ExportPreference
    @AppStorage("settings.moveCheckedToBottom") private var moveCheckedToBottom = true
    @AppStorage("settings.hapticsEnabled") private var hapticFeedback = true
    @AppStorage("settings.uncheckAllOnReset") private var uncheckAllOnReset = false
    @AppStorage("settings.collapsePacked") private var collapsePacked = false
    @State private var showRestoreAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                header

                proCard

                SettingsSection(title: "Preferences") {
                    SettingsCard {
                        SettingsToggleRow(
                            icon: "arrow.down.to.line",
                            title: "Move checked to bottom",
                            isOn: $moveCheckedToBottom
                        )
                        SettingsDivider()
                        SettingsToggleRow(
                            icon: "iphone.radiowaves.left.and.right",
                            title: "Haptic Feedback",
                            isOn: $hapticFeedback
                        )
                        .onChange(of: hapticFeedback) { _, newValue in
                            if newValue {
                                Haptics.impact(.light)
                            }
                        }
                        SettingsDivider()
                        SettingsToggleRow(
                            icon: "rectangle.compress.vertical",
                            title: "Collapse packed items",
                            isOn: $collapsePacked
                        )
                        SettingsDivider()
                        SettingsToggleRow(
                            icon: "arrow.counterclockwise",
                            title: "Uncheck all on reset",
                            isOn: $uncheckAllOnReset
                        )
                    }
                }

                SettingsSection(title: "Data") {
                    SettingsCard {
                        SettingsActionRow(
                            icon: "icloud",
                            title: "iCloud Sync",
                            subtitle: "Last synced 2m ago",
                            showsChevron: true
                        ) {}
                        SettingsDivider()
                        SettingsActionRow(
                            icon: "square.and.arrow.up",
                            title: "Export Defaults",
                            trailingText: exportPreference.rawValue,
                            showsChevron: true
                        ) {
                            exportPreference.toggle()
                        }
                    }
                }

                SettingsSection(title: "Support") {
                    SettingsCard {
                        SettingsActionRow(
                            icon: "arrow.clockwise",
                            title: "Restore Purchases",
                            titleColor: AppTheme.Colors.primary
                        ) {
                            showRestoreAlert = true
                        }
                        SettingsDivider()
                        SettingsActionRow(
                            icon: "star",
                            title: "Rate PackOnce",
                            trailingIcon: "arrow.up.right"
                        ) {}
                        SettingsDivider()
                        SettingsActionRow(
                            icon: "envelope",
                            title: "Send Feedback",
                            showsChevron: true
                        ) {}
                    }
                }

                footer
            }
            .padding(AppTheme.Spacing.xl)
        }
        .alert("Restore Purchases", isPresented: $showRestoreAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("We’ll attempt to restore previous purchases in a future update.")
        }
    }

    private var header: some View {
        Text("Settings")
            .font(AppTheme.Typography.title())
            .foregroundStyle(AppTheme.Colors.textPrimary)
    }

    private var proCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Text("PackOnce Pro")
                            .font(AppTheme.Typography.headline())
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        Text(purchaseManager.isProActive ? "ACTIVE" : "INACTIVE")
                            .font(AppTheme.Typography.caption())
                            .foregroundStyle(AppTheme.Colors.primary)
                            .padding(.horizontal, AppTheme.Spacing.sm)
                            .padding(.vertical, 2)
                            .background(
                                Capsule().fill(AppTheme.Colors.primary.opacity(0.2))
                            )
                    }
                    Text("Unlock unlimited packs,\nadvanced export options, and\ncloud sync.")
                        .font(AppTheme.Typography.body())
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primary.opacity(0.2))
                        .frame(width: 52, height: 52)
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.primary)
                }
            }

            Button {} label: {
                Text("Manage Subscription")
            .font(AppTheme.Typography.callout())
            .foregroundStyle(AppTheme.Colors.primary)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                    .stroke(AppTheme.Colors.primary.opacity(0.6), lineWidth: 1)
            )
            }
            .buttonStyle(.plain)
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                .fill(AppTheme.Colors.surfaceElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                        .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                )
        )
        .applyShadow(AppTheme.Shadows.subtle)
    }

    private var footer: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "checklist")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.primary)
                .padding(AppTheme.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                        .fill(AppTheme.Colors.surfaceElevated)
                )
            Text("PackOnce v1.0.2")
                .font(AppTheme.Typography.callout())
                .foregroundStyle(AppTheme.Colors.textSecondary)
            HStack(spacing: AppTheme.Spacing.lg) {
                Button("Privacy Policy") {}
                    .padding(.vertical, 6)
                Button("Terms of Service") {}
                    .padding(.vertical, 6)
            }
            .font(AppTheme.Typography.caption())
            .foregroundStyle(AppTheme.Colors.textSecondary)
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppTheme.Spacing.lg)
    }
}

private struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title.uppercased()
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(title)
            .font(AppTheme.Typography.caption())
            .foregroundStyle(AppTheme.Colors.textSecondary)
            .tracking(1.5)
            content
        }
    }
}

private struct SettingsCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                .fill(AppTheme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                        .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                )
        )
        .applyShadow(AppTheme.Shadows.subtle)
    }
}

private struct SettingsDivider: View {
    var body: some View {
        Divider()
            .background(AppTheme.Colors.surfaceBorder)
            .padding(.leading, AppTheme.Spacing.lg + 40)
    }
}

private struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            SettingsIcon(icon: icon)
            Text(title)
                .font(AppTheme.Typography.callout())
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppTheme.Colors.primary)
                .accessibilityLabel(Text(title))
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.md)
        .frame(minHeight: 52)
    }
}

private struct SettingsActionRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let trailingText: String?
    let trailingIcon: String?
    let showsChevron: Bool
    let titleColor: Color
    let action: () -> Void

    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        trailingText: String? = nil,
        trailingIcon: String? = nil,
        showsChevron: Bool = false,
        titleColor: Color = AppTheme.Colors.textPrimary,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.trailingText = trailingText
        self.trailingIcon = trailingIcon
        self.showsChevron = showsChevron
        self.titleColor = titleColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                SettingsIcon(icon: icon)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppTheme.Typography.callout())
                        .foregroundStyle(titleColor)
                        .fixedSize(horizontal: false, vertical: true)
                    if let subtitle {
                        Text(subtitle)
                            .font(AppTheme.Typography.caption())
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer()
                if let trailingText {
                    Text(trailingText)
                        .font(AppTheme.Typography.callout())
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
                if let trailingIcon {
                    Image(systemName: trailingIcon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .frame(minHeight: 52)
        }
        .buttonStyle(.plain)
    }
}

private struct SettingsIcon: View {
    let icon: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.Radii.sm)
                .fill(AppTheme.Colors.surfaceElevated)
                .frame(width: 40, height: 40)
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textPrimary)
        }
    }
}

#Preview {
    SettingsPreviewWrapper()
}

private struct SettingsPreviewWrapper: View {
    @StateObject private var purchaseManager = PurchaseManager(isProActive: true)
    @State private var exportPreference: ExportPreference = .pdf

    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Toggle("Debug: Pro Active", isOn: $purchaseManager.isProActive)
                .tint(AppTheme.Colors.primary)
                .padding(.horizontal, AppTheme.Spacing.xl)
            SettingsView(
                purchaseManager: purchaseManager,
                exportPreference: $exportPreference
            )
        }
        .background(AppBackgroundView())
    }
}
