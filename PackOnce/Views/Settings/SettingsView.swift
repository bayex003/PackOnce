import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("moveCheckedToBottom") private var moveCheckedToBottom = true
    @AppStorage("collapsePacked") private var collapsePacked = true
    @AppStorage("enableHaptics") private var enableHaptics = true
    @AppStorage("largeTextMode") private var largeText = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = true
    @EnvironmentObject private var storeKit: StoreKitService
    @EnvironmentObject private var paywallState: PaywallState
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        NavigationStack {
            List {
                Section("Packing") {
                    SettingToggleRow(title: "Move checked to bottom", description: "Keep packed items out of the way.", isOn: $moveCheckedToBottom)
                    SettingToggleRow(title: "Collapse packed", description: "Hide items once marked packed.", isOn: $collapsePacked)
                    SettingToggleRow(title: "Haptics", description: "Light taps while checking items.", isOn: $enableHaptics)
                }

                Section("Accessibility") {
                    SettingToggleRow(title: "Large text mode", description: "Boost typography for comfort.", isOn: $largeText)
                }

                Section("Exports") {
                    Text("Text share is free. PDF export requires Pro.")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.secondary(scheme))
                }

                Section("Pro") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(storeKit.isProUnlocked(debugOverride: paywallState.debugProUnlocked) ? "PackOnce Pro" : "Locked")
                                .font(.headline)
                            Text("Upgrade to export PDF and unlock premium templates.")
                                .font(.caption)
                                .foregroundStyle(AppTheme.secondary(scheme))
                        }
                        Spacer()
                        Button("Upgrade") {
                            paywallState.isPresented = true
                        }
                    }
                    Button("Restore purchases") {
                        Task { await storeKit.restore() }
                    }
                    ProDebugToggle()
                }

                Section("Support") {
                    Link("Email support", destination: URL(string: "mailto:support@packonce.app")!)
                    Button("Restart onboarding") { hasSeenOnboarding = false }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $paywallState.isPresented) {
                PaywallView()
            }
        }
    }
}
