import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var context
    @Environment(\._largeTextEnabled) private var largeTextEnabled
    @AppStorage("moveCheckedToBottom") private var moveCheckedToBottom = true
    @AppStorage("collapsePacked") private var collapsePacked = true
    @AppStorage("enableHaptics") private var enableHaptics = true
    @Binding var hasSeenOnboarding: Bool
    @State private var showOnboarding = false

    @Query(sort: \PackModel.lastOpened, order: .reverse) private var packs: [PackModel]

    var body: some View {
        Group {
            if hasSeenOnboarding {
                TabView {
                    PacksView()
                        .tabItem {
                            Label("Packs", systemImage: "checklist")
                        }
                    TemplatesView()
                        .tabItem {
                            Label("Templates", systemImage: "square.grid.2x2")
                        }
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                }
                .environment(\.dynamicTypeSize, largeTextEnabled ? .accessibility3 : .large)
                .task {
                    SeedData.ensureSeeded(context: context)
                }
            } else {
                OnboardingView(onFinished: completeOnboarding)
            }
        }
        .onAppear {
            SeedData.ensureSeeded(context: context)
            showOnboarding = !hasSeenOnboarding
        }
    }

    private func completeOnboarding() {
        hasSeenOnboarding = true
        showOnboarding = false
    }
}
