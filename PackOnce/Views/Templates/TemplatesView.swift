import SwiftUI
import SwiftData

struct TemplatesView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var paywallState: PaywallState
    @EnvironmentObject private var storeKit: StoreKitService
    @State private var showNewTemplate = false

    @Query(filter: #Predicate<TemplateModel> { !$0.isPremium }, sort: \TemplateModel.createdAt) private var templates: [TemplateModel]
    @Query(filter: #Predicate<TemplateModel> { $0.isPremium }, sort: \TemplateModel.createdAt) private var premiumTemplates: [TemplateModel]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Templates")
                        .font(.largeTitle.bold())
                    Text("Create once, reuse often."
                    )
                    .foregroundStyle(AppTheme.secondary(scheme))

                    SectionHeader(title: "My templates")
                    ForEach(templates) { template in
                        NavigationLink {
                            TemplateEditorView(template: template)
                        } label: {
                            TemplateCard(template: template, locked: false) {}
                        }
                        .buttonStyle(.plain)
                    }

                    SectionHeader(title: "Premium previews")
                    ForEach(premiumTemplates) { template in
                        TemplateCard(template: template, locked: true) {
                            paywallState.isPresented = true
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Templates")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showNewTemplate = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewTemplate) {
                TemplateEditorView(template: TemplateModel(name: "New Template", typeTag: .home))
                    .modelContainer(context.container)
            }
            .sheet(isPresented: $paywallState.isPresented) {
                PaywallView()
            }
        }
    }
}

private struct SectionHeader: View {
    var title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.title3.bold())
            Spacer()
        }
    }
}
