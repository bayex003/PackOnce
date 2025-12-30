import SwiftUI

struct CardContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
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
    }
}

struct PrimaryCTAButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Typography.callout())
                .foregroundStyle(.black)
                .padding(.vertical, AppTheme.Spacing.sm)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .background(
                    Capsule().fill(AppTheme.Colors.primary)
                )
                .applyShadow(AppTheme.Shadows.glow)
        }
        .buttonStyle(.plain)
    }
}

struct PillChip: View {
    let title: String
    let icon: String?

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xs) {
            if let icon {
                Image(systemName: icon)
            }
            Text(title)
        }
        .font(AppTheme.Typography.caption())
        .foregroundStyle(AppTheme.Colors.textSecondary)
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.xs)
        .background(
            Capsule().fill(AppTheme.Colors.surfaceElevated)
        )
    }
}

struct PillSegment: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(AppTheme.Typography.callout())
            .foregroundStyle(isSelected ? .black : AppTheme.Colors.textSecondary)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(
                Capsule().fill(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.surfaceElevated)
            )
    }
}

struct TagBadge: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppTheme.Typography.caption())
            .foregroundStyle(AppTheme.Colors.primary)
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, 2)
            .background(
                Capsule().fill(AppTheme.Colors.primary.opacity(0.15))
            )
    }
}

struct ProgressRing: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.Colors.surfaceElevated, lineWidth: 8)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppTheme.Colors.primary, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 56, height: 56)
    }
}

struct ToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTheme.Typography.callout())
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text(subtitle)
                    .font(AppTheme.Typography.caption())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(AppTheme.Colors.primary)
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                .fill(AppTheme.Colors.surface)
        )
    }
}

struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.black)
                .frame(width: 52, height: 52)
                .background(
                    Circle().fill(AppTheme.Colors.primary)
                )
                .applyShadow(AppTheme.Shadows.glow)
        }
        .buttonStyle(.plain)
    }
}
