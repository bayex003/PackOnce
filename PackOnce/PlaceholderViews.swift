import SwiftUI
import SwiftData

struct PacksPlaceholderView: View {
    @Query(sort: \Pack.createdAt, order: .reverse) private var packs: [Pack]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                header

                HStack(spacing: AppTheme.Spacing.sm) {
                    PillSegment(title: "Upcoming", isSelected: true)
                    PillSegment(title: "Archived", isSelected: false)
                }

                ForEach(packs) { pack in
                    CardContainer {
                        HStack(spacing: AppTheme.Spacing.lg) {
                            ProgressRing(progress: pack.progress)

                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                Text(pack.name)
                                    .font(AppTheme.Typography.headline())
                                    .foregroundStyle(AppTheme.Colors.textPrimary)
                                Text("\(pack.totalQuantity) items • \(Int(pack.progress * 100))% packed")
                                    .font(AppTheme.Typography.caption())
                                    .foregroundStyle(AppTheme.Colors.textSecondary)
                                HStack(spacing: AppTheme.Spacing.sm) {
                                    TagBadge(title: pack.tagName)
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
    private struct TemplateRow: Identifiable {
        let id = UUID()
        let title: String
        let itemCount: Int
        let icon: String
        let iconColor: Color
        let iconBackground: Color
        let showsChevron: Bool
        let showsLock: Bool
        let isDisabled: Bool
    }

    private let myTemplates: [TemplateRow] = [
        TemplateRow(
            title: "Camping Trip",
            itemCount: 24,
            icon: "tent.fill",
            iconColor: Color(red: 0.42, green: 0.64, blue: 1.0),
            iconBackground: Color(red: 0.14, green: 0.22, blue: 0.36),
            showsChevron: true,
            showsLock: false,
            isDisabled: false
        ),
        TemplateRow(
            title: "Weekly Groceries",
            itemCount: 15,
            icon: "basket.fill",
            iconColor: Color(red: 0.35, green: 0.88, blue: 0.72),
            iconBackground: Color(red: 0.12, green: 0.28, blue: 0.26),
            showsChevron: true,
            showsLock: false,
            isDisabled: false
        ),
        TemplateRow(
            title: "Gym Routine",
            itemCount: 8,
            icon: "dumbbell.fill",
            iconColor: Color(red: 1.0, green: 0.60, blue: 0.32),
            iconBackground: Color(red: 0.28, green: 0.20, blue: 0.14),
            showsChevron: true,
            showsLock: false,
            isDisabled: false
        )
    ]

    private let premiumTemplates: [TemplateRow] = [
        TemplateRow(
            title: "International Travel",
            itemCount: 45,
            icon: "airplane",
            iconColor: Color(red: 0.44, green: 0.50, blue: 0.92),
            iconBackground: Color(red: 0.16, green: 0.18, blue: 0.32),
            showsChevron: false,
            showsLock: true,
            isDisabled: true
        ),
        TemplateRow(
            title: "Newborn Essentials",
            itemCount: 60,
            icon: "face.smiling.fill",
            iconColor: Color(red: 0.86, green: 0.52, blue: 0.78),
            iconBackground: Color(red: 0.28, green: 0.18, blue: 0.28),
            showsChevron: false,
            showsLock: true,
            isDisabled: true
        ),
        TemplateRow(
            title: "Wedding Planner",
            itemCount: 68,
            icon: "sparkles",
            iconColor: Color(red: 0.72, green: 0.52, blue: 1.0),
            iconBackground: Color(red: 0.20, green: 0.18, blue: 0.30),
            showsChevron: false,
            showsLock: true,
            isDisabled: true
        )
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                header

                newTemplateCard

                sectionHeader(title: "MY TEMPLATES", trailing: "3 saved")

                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(myTemplates) { template in
                        templateRow(template)
                    }
                }

                premiumHeader

                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(premiumTemplates) { template in
                        templateRow(template)
                    }
                }
            }
            .padding(AppTheme.Spacing.xl)
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            Text("Templates")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
            Button(action: {}) {
                Text("Edit")
                    .font(AppTheme.Typography.callout())
                    .foregroundStyle(AppTheme.Colors.primary)
            }
            .buttonStyle(.plain)
        }
    }

    private var newTemplateCard: some View {
        Button(action: {}) {
            HStack(spacing: AppTheme.Spacing.lg) {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.18))
                        .frame(width: 40, height: 40)
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.black.opacity(0.8))
                }
                Text("New Template")
                    .font(AppTheme.Typography.headline())
                    .foregroundStyle(Color.black)
                Spacer()
            }
            .padding(.vertical, AppTheme.Spacing.lg)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                    .fill(AppTheme.Colors.primary)
            )
            .applyShadow(AppTheme.Shadows.glow)
        }
        .buttonStyle(.plain)
    }

    private func sectionHeader(title: String, trailing: String) -> some View {
        HStack {
            Text(title)
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .tracking(1.2)
            Spacer()
            Text(trailing)
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.primary)
        }
    }

    private var premiumHeader: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Text("PREMIUM PACKS")
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .tracking(1.2)
            Text("PRO")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.Colors.primary)
                .padding(.horizontal, AppTheme.Spacing.sm)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(AppTheme.Colors.primary.opacity(0.18))
                )
            Spacer()
        }
    }

    private func templateRow(_ template: TemplateRow) -> some View {
        HStack(spacing: AppTheme.Spacing.lg) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                    .fill(template.iconBackground)
                    .frame(width: 48, height: 48)
                Image(systemName: template.icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(template.iconColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(template.title)
                    .font(AppTheme.Typography.headline())
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("\(template.itemCount) items")
                    .font(AppTheme.Typography.caption())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }

            Spacer()

            if template.showsLock {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primaryMuted.opacity(0.25))
                        .frame(width: 32, height: 32)
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.primary)
                }
            } else if template.showsChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.surfaceBorder)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                .fill(AppTheme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                        .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                )
        )
        .applyShadow(AppTheme.Shadows.subtle)
        .opacity(template.isDisabled ? 0.55 : 1.0)
    }
}

#Preview {
    PacksPlaceholderView()
        .modelContainer(for: [Pack.self, Template.self, TemplateItem.self, PackItem.self, Tag.self], inMemory: true)
}
