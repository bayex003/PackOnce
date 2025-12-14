import SwiftUI

struct PaywallView: View {
    @EnvironmentObject private var storeKit: StoreKitService
    @EnvironmentObject private var paywallState: PaywallState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Text("PackOnce Pro")
                    .font(.largeTitle.bold())
                Text("Unlock PDF exports, premium templates, and more smart reminders.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppTheme.secondary(scheme))
            }
            .padding(.top, 20)

            VStack(alignment: .leading, spacing: 12) {
                featureRow(icon: "doc.text", title: "PDF export", subtitle: "Beautiful offline-friendly exports")
                featureRow(icon: "star", title: "Premium templates", subtitle: "Camping, newborn, and emergency kits")
                featureRow(icon: "bell", title: "Smart nudges", subtitle: "Last-minute reminders without network")
            }
            .padding()
            .background(AppTheme.surface(scheme))
            .cornerRadius(16)

            if let price = storeKit.proProduct?.displayPrice {
                Button("Upgrade for \(price)") {
                    Task {
                        _ = await storeKit.purchase()
                        dismiss()
                    }
                }
                .buttonStyle(AccentButtonStyle())
                .padding(.horizontal)
            } else {
                Button("Upgrade to Pro") {
                    Task {
                        _ = await storeKit.purchase()
                        dismiss()
                    }
                }
                .buttonStyle(AccentButtonStyle())
                .padding(.horizontal)
            }

            Button("Restore purchases") {
                Task { await storeKit.restore() }
            }
            .buttonStyle(OutlineButtonStyle())
            .padding(.horizontal)

            Button("Not now", action: dismiss.callAsFunction)
                .tint(AppTheme.secondary(scheme))
                .padding(.top, 12)
        }
        .padding()
    }

    private func featureRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.accent(scheme))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondary(scheme))
            }
            Spacer()
        }
    }
}
