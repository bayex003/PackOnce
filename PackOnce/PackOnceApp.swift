import SwiftUI
import SwiftData

@main
struct PackOnceApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    private let container: ModelContainer = {
        let schema = Schema([Pack.self, Template.self, TemplateItem.self, PackItem.self, Tag.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [configuration])
    }()

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                RootView()
                    .task {
                        DataSeeder.seedIfNeeded(context: container.mainContext)
                    }
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .modelContainer(container)
    }
}
