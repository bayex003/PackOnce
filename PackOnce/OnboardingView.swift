import SwiftUI

private struct OnboardingSlide: Identifiable {
    let id: Int
    let imageName: String
    let title: String
    let subtitle: String
}

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @Environment(\.dismiss) private var dismiss
    @State private var selection = 0

    private let slides: [OnboardingSlide] = [
        OnboardingSlide(
            id: 0,
            imageName: "onboarding_arch",
            title: "Don't wing it. Vault it.",
            subtitle: "Build your story bank. Master behavioral interviews with confidence."
        ),
        OnboardingSlide(
            id: 1,
            imageName: "onboarding_open",
            title: "Organize your career.",
            subtitle: "Stop memorizing answers. Map your best moments to any interview question."
        ),
        OnboardingSlide(
            id: 2,
            imageName: "onboarding_stack",
            title: "Ace the interview.",
            subtitle: "Never freeze up. Have your structured STAR stories ready for any scenario."
        )
    ]

    var body: some View {
        ZStack {
            AppTheme.Colors.paperCream
                .ignoresSafeArea()

            VStack(spacing: 24) {
                TabView(selection: $selection) {
                    ForEach(slides) { slide in
                        OnboardingSlideView(slide: slide)
                            .tag(slide.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                VStack(spacing: 16) {
                    OnboardingPagingDots(currentIndex: selection, total: slides.count)

                    Button(action: handlePrimaryAction) {
                        Text(selection == slides.count - 1 ? "Get Started" : "Next")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule().fill(AppTheme.Colors.sageGreen)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 24)
                }
            }
            .padding(.vertical, 32)
        }
    }

    private func handlePrimaryAction() {
        if selection < slides.count - 1 {
            withAnimation(.easeInOut) {
                selection += 1
            }
        } else {
            hasSeenOnboarding = true
            dismiss()
        }
    }
}

private struct OnboardingSlideView: View {
    let slide: OnboardingSlide

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 0)

            Image(slide.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 260)

            VStack(spacing: 12) {
                Text(slide.title)
                    .modifier(SerifTitle())
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)

                Text(slide.subtitle)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.gray.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.paperCream)
    }
}

private struct OnboardingPagingDots: View {
    let currentIndex: Int
    let total: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? AppTheme.Colors.sageGreen : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
