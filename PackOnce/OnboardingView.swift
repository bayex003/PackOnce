import SwiftUI

private struct OnboardingPage: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let ctaTitle: String
    let showsLogin: Bool
    let showsSkip: Bool
    let hero: AnyView
}

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var selection = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            title: "Pack smarter, not harder.",
            subtitle: "Create reusable packs that ensure you never forget the tiny stuff again.",
            ctaTitle: "Get Started",
            showsLogin: true,
            showsSkip: false,
            hero: AnyView(OnboardingHeroSuitcase())
        ),
        OnboardingPage(
            id: 1,
            title: "Ready in Seconds",
            subtitle: "Choose a template. Reuse it forever.\nNever forget an item again.",
            ctaTitle: "Continue",
            showsLogin: false,
            showsSkip: true,
            hero: AnyView(OnboardingHeroCards())
        ),
        OnboardingPage(
            id: 2,
            title: "Ready when you are",
            subtitle: "No sign-ups. No loading screens.\nPackOnce stores everything locally on\nyour device for instant access.",
            ctaTitle: "Start Packing",
            showsLogin: false,
            showsSkip: false,
            hero: AnyView(OnboardingHeroOffline())
        )
    ]

    var body: some View {
        ZStack {
            AppBackgroundView()

            VStack(spacing: AppTheme.Spacing.xl) {
                header

                TabView(selection: $selection) {
                    ForEach(pages) { page in
                        OnboardingPageView(page: page) {
                            handleCTA(for: page.id)
                        }
                        .tag(page.id)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                OnboardingPageDots(currentIndex: selection, total: pages.count)
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.top, AppTheme.Spacing.lg)
            .padding(.bottom, AppTheme.Spacing.xxl)
        }
    }

    private var header: some View {
        HStack {
            if selection != 1 {
                OnboardingBrandLockup()
                Spacer()
            } else {
                Spacer()
                OnboardingBrandLockup()
                Spacer()
            }

            if pages[selection].showsSkip {
                Button("Skip") {
                    hasCompletedOnboarding = true
                }
                .font(AppTheme.Typography.callout())
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .buttonStyle(.plain)
            }
        }
    }

    private func handleCTA(for index: Int) {
        if index < pages.count - 1 {
            withAnimation(.easeInOut) {
                selection += 1
            }
        } else {
            hasCompletedOnboarding = true
        }
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage
    let ctaAction: () -> Void

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            page.hero
                .frame(maxWidth: .infinity)

            VStack(spacing: AppTheme.Spacing.md) {
                Text(page.title)
                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(AppTheme.Typography.body())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer(minLength: 0)

            VStack(spacing: AppTheme.Spacing.md) {
                OnboardingCTAButton(title: page.ctaTitle, action: ctaAction)

                if page.showsLogin {
                    HStack(spacing: AppTheme.Spacing.xs) {
                        Text("Already have an account?")
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                        Text("Log in")
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                    .font(AppTheme.Typography.callout())
                }
            }
        }
        .padding(.top, AppTheme.Spacing.xxl)
    }
}

private struct OnboardingCTAButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Text(title)
                Image(systemName: "arrow.right")
            }
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                    .fill(AppTheme.Colors.primary)
            )
            .applyShadow(AppTheme.Shadows.glow)
        }
        .buttonStyle(.plain)
    }
}

private struct OnboardingPageDots: View {
    let currentIndex: Int
    let total: Int

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ForEach(0..<total, id: \.self) { index in
                if index == currentIndex {
                    Capsule()
                        .fill(AppTheme.Colors.primary)
                        .frame(width: 28, height: 6)
                        .applyShadow(AppTheme.Shadows.glow)
                } else {
                    Circle()
                        .fill(AppTheme.Colors.surfaceElevated.opacity(0.7))
                        .frame(width: 7, height: 7)
                }
            }
        }
        .padding(.bottom, AppTheme.Spacing.lg)
    }
}

private struct OnboardingBrandLockup: View {
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                    .fill(AppTheme.Colors.primary)
                Image(systemName: "briefcase.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)
            }
            .frame(width: 28, height: 28)

            Text("PackOnce")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.Colors.textPrimary)
        }
    }
}

private struct OnboardingHeroSuitcase: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.Colors.surfaceElevated, AppTheme.Colors.backgroundBottom],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 260)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                        .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                )

            VStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.Colors.surfaceElevated, AppTheme.Colors.surface],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 220, height: 220)
                        .applyShadow(AppTheme.Shadows.soft)

                    Image(systemName: "suitcase.fill")
                        .font(.system(size: 64, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.primary)
                }

                HStack(spacing: AppTheme.Spacing.sm) {
                    Capsule()
                        .fill(AppTheme.Colors.primaryMuted)
                        .frame(width: 48, height: 6)
                    Capsule()
                        .fill(AppTheme.Colors.surfaceElevated)
                        .frame(width: 24, height: 6)
                }
            }

            Circle()
                .fill(AppTheme.Colors.primary)
                .frame(width: 14, height: 14)
                .offset(x: -120, y: -64)
        }
    }
}

private struct OnboardingHeroCards: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                .fill(AppTheme.Colors.surface)
                .frame(height: 260)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                        .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                )

            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                    .fill(AppTheme.Colors.surfaceElevated)
                    .frame(width: 220, height: 170)
                    .offset(x: -8, y: -8)

                RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.Colors.surfaceElevated, AppTheme.Colors.surface],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 220, height: 170)
                    .overlay(
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            HStack {
                                Circle()
                                    .fill(AppTheme.Colors.primary)
                                    .frame(width: 12, height: 12)
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 60, height: 8)
                                Spacer()
                                HStack(spacing: 4) {
                                    Circle()
                                        .fill(AppTheme.Colors.textSecondary.opacity(0.6))
                                        .frame(width: 6, height: 6)
                                    Circle()
                                        .fill(AppTheme.Colors.textSecondary.opacity(0.6))
                                        .frame(width: 6, height: 6)
                                    Circle()
                                        .fill(AppTheme.Colors.textSecondary.opacity(0.6))
                                        .frame(width: 6, height: 6)
                                }
                            }
                            .padding(.bottom, AppTheme.Spacing.xs)

                            HStack(alignment: .bottom, spacing: AppTheme.Spacing.sm) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppTheme.Colors.primaryMuted)
                                    .frame(width: 70, height: 70)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppTheme.Colors.surface)
                                    .frame(width: 50, height: 90)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppTheme.Colors.surfaceElevated)
                                    .frame(width: 40, height: 120)
                            }
                            .frame(maxWidth: .infinity)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppTheme.Colors.surfaceElevated.opacity(0.7))
                                .frame(width: 110, height: 10)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(AppTheme.Colors.surfaceElevated.opacity(0.7))
                                .frame(width: 140, height: 10)
                            Spacer()
                            HStack(spacing: AppTheme.Spacing.sm) {
                                Circle()
                                    .fill(AppTheme.Colors.primary)
                                    .frame(width: 30, height: 30)
                                VStack(alignment: .leading, spacing: 4) {
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(AppTheme.Colors.surfaceElevated.opacity(0.8))
                                        .frame(width: 90, height: 8)
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(AppTheme.Colors.surfaceElevated.opacity(0.6))
                                        .frame(width: 60, height: 8)
                                }
                            }
                        }
                        .padding(AppTheme.Spacing.md)
                    )
                    .applyShadow(AppTheme.Shadows.soft)

                HStack(spacing: AppTheme.Spacing.sm) {
                    Circle()
                        .fill(AppTheme.Colors.primary)
                        .frame(width: 18, height: 18)
                    Text("10s setup")
                        .font(AppTheme.Typography.callout())
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                        .fill(AppTheme.Colors.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                                .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                        )
                )
                .offset(x: 90, y: -40)
            }
        }
    }
}

private struct OnboardingHeroOffline: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                .fill(
                    LinearGradient(
                        colors: [AppTheme.Colors.surface, AppTheme.Colors.surfaceElevated],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 260)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                        .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                )

            ZStack {
                Circle()
                    .stroke(AppTheme.Colors.primaryMuted.opacity(0.3), lineWidth: 3)
                    .frame(width: 180, height: 180)
                Circle()
                    .stroke(AppTheme.Colors.primaryMuted.opacity(0.5), lineWidth: 3)
                    .frame(width: 130, height: 130)

                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.surfaceElevated)
                        .frame(width: 86, height: 86)
                    Image(systemName: "icloud.slash")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.primary)
                }
                .applyShadow(AppTheme.Shadows.subtle)

                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.surface)
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                        )
                    Image(systemName: "lock.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppTheme.Colors.primary)
                }
                .offset(x: 70, y: 50)
            }
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
