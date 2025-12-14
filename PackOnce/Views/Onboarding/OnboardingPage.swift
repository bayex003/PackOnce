import SwiftUI

struct OnboardingPage: View {
    var title: String
    var message: String
    var gradient: Gradient

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 200, height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.white.opacity(0.2), lineWidth: 4)
                            .padding(24)
                    )
                    .shadow(radius: 10, y: 8)
                RoundedRectangle(cornerRadius: 24)
                    .fill(.thinMaterial)
                    .frame(width: 160, height: 110)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "checklist")
                                .font(.largeTitle)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 120, height: 8)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 90, height: 8)
                        }
                        .foregroundStyle(.white)
                    )
            }
            Text(title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            Text(message)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
