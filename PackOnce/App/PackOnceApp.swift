import SwiftUI
import SwiftData

@main
struct PackOnceApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("largeTextMode") private var largeTextMode = false
    @StateObject private var storeKit = StoreKitService()
    @StateObject private var paywallState = PaywallState()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TemplateModel.self,
            TemplateItemModel.self,
            PackModel.self,
            PackItemModel.self,
            SettingsModel.self
        ])
        let configuration = ModelConfiguration()
        return try! ModelContainer(for: schema, configurations: [configuration])
    }()

    var body: some Scene {
        WindowGroup {
            RootView(hasSeenOnboarding: $hasSeenOnboarding)
                .environmentObject(storeKit)
                .environmentObject(paywallState)
                .environment(\._largeTextEnabled, largeTextMode)
                .task {
                    await storeKit.load()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

private struct LargeTextKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var _largeTextEnabled: Bool {
        get { self[LargeTextKey.self] }
        set { self[LargeTextKey.self] = newValue }
    }
}
