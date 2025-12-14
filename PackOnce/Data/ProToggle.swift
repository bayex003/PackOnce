import SwiftUI

struct ProDebugToggle: View {
    @EnvironmentObject private var paywallState: PaywallState

    var body: some View {
        Toggle("Simulate Pro (DEBUG)", isOn: $paywallState.debugProUnlocked)
            .font(.caption)
            .tint(.orange)
            .opacity(isDebug ? 1 : 0.001)
            .accessibilityHidden(!isDebug)
    }

    private var isDebug: Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }
}
