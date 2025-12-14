import SwiftUI

struct OnboardingView: View {
    var onFinished: () -> Void
    @State private var selection = 0

    var body: some View {
        VStack {
            TabView(selection: $selection) {
                OnboardingPage(
                    title: "PackOnce",
                    message: "One checklist for every adventure with packs that stay in sync offline.",
                    gradient: Gradient(colors: [.teal, .mint])
                )
                .tag(0)
                OnboardingPage(
                    title: "Start from templates",
                    message: "Pick a template first so you never start from scratch again.",
                    gradient: Gradient(colors: [.blue, .purple])
                )
                .tag(1)
                OnboardingPage(
                    title: "Offline-first",
                    message: "Everything is saved on-device. Add reminders and packing nudges without signal.",
                    gradient: Gradient(colors: [.orange, .pink])
                )
                .tag(2)
            }
            .tabViewStyle(.page)

            HStack {
                Spacer()
                Button(action: finish) {
                    Label(selection == 2 ? "Get started" : "Next", systemImage: selection == 2 ? "sparkles" : "arrow.right")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(AccentButtonStyle())
                .padding()
            }
        }
        .background(AppTheme.background(.light))
    }

    private func finish() {
        if selection < 2 {
            selection += 1
        } else {
            onFinished()
        }
    }
}
