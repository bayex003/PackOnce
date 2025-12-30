import SwiftUI

struct PacksPlaceholderView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                header

                HStack(spacing: AppTheme.Spacing.sm) {
                    PillSegment(title: "Upcoming", isSelected: true)
                    PillSegment(title: "Archived", isSelected: false)
                }

                ForEach(SampleData.packs) { pack in
                    CardContainer {
                        HStack(spacing: AppTheme.Spacing.lg) {
                            ProgressRing(progress: pack.completion)

                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                Text(pack.name)
                                    .font(AppTheme.Typography.headline())
                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                Text("\(pack.itemCount) items • \(Int(pack.completion * 100))% packed")
                                    .font(AppTheme.Typography.caption())
                                    .foregroundStyle(AppTheme.Colors.textSecondary)
                                HStack(spacing: AppTheme.Spacing.sm) {
                                    ForEach(pack.tags, id: \.self) { tag in
                                        TagBadge(title: tag)
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                }

                FloatingActionButton(icon: "plus") {
                    // Placeholder action
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(AppTheme.Spacing.xl)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Your Packs")
                .font(AppTheme.Typography.title())
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Text("Stay on top of every trip with progress at a glance.")
                .font(AppTheme.Typography.body())
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
    }
}

struct TemplatesPlaceholderView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                header

                CardContainer {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Smart Suggestions")
                            .font(AppTheme.Typography.headline())
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        Text("Customize a template and get packing in minutes.")
                            .font(AppTheme.Typography.body())
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                        HStack(spacing: AppTheme.Spacing.sm) {
                            PillChip(title: "Auto-sort", icon: "sparkles")
                            PillChip(title: "Weather-aware", icon: "cloud.sun")
                        }
                        PrimaryCTAButton(title: "Browse Templates") {}
                    }
                }

                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(SampleData.templates) { template in
                        CardContainer {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                HStack {
                                    Text(template.title)
                                        .font(AppTheme.Typography.headline())
                                        .foregroundStyle(AppTheme.Colors.textPrimary)
                                    Spacer()
                                    TagBadge(title: template.category)
                                }
                                Text(template.description)
                                    .font(AppTheme.Typography.body())
                                    .foregroundStyle(AppTheme.Colors.textSecondary)
                            }
                        }
                    }
                }
            }
            .padding(AppTheme.Spacing.xl)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Templates")
                .font(AppTheme.Typography.title())
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Text("Reusable lists for every adventure.")
                .font(AppTheme.Typography.body())
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
    }
}

struct SettingsPlaceholderView: View {
    @State private var smartReminders = true
    @State private var packSync = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                header

                CardContainer {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Packing Status")
                            .font(AppTheme.Typography.headline())
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        HStack(spacing: AppTheme.Spacing.lg) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Ready for your next trip")
                                    .font(AppTheme.Typography.callout())
                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                Text("3 packs in progress")
                                    .font(AppTheme.Typography.caption())
                                    .foregroundStyle(AppTheme.Colors.textSecondary)
                            }
                            Spacer()
                            ProgressRing(progress: 0.64)
                        }
                    }
                }

                ToggleRow(
                    title: "Smart reminders",
                    subtitle: "Nudges before departure.",
                    isOn: $smartReminders
                )

                ToggleRow(
                    title: "Pack sync",
                    subtitle: "Share lists across devices.",
                    isOn: $packSync
                )

                CardContainer {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        Text("Quick actions")
                            .font(AppTheme.Typography.headline())
                            .foregroundStyle(AppTheme.Colors.textPrimary)
                        HStack(spacing: AppTheme.Spacing.sm) {
                            PrimaryCTAButton(title: "Start new pack") {}
                            PillChip(title: "Help", icon: "questionmark.circle")
                        }
                    }
                }
            }
            .padding(AppTheme.Spacing.xl)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Settings")
                .font(AppTheme.Typography.title())
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Text("Fine-tune how PackOnce keeps you ready.")
                .font(AppTheme.Typography.body())
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
    }
}

#Preview {
    PacksPlaceholderView()
}
