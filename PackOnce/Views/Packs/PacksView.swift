import SwiftUI
import SwiftData

struct PacksView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var paywallState: PaywallState
    @EnvironmentObject private var storeKit: StoreKitService
    @State private var searchText = ""
    @State private var showingNewPack = false

    @Query(sort: \PackModel.lastOpened, order: .reverse) private var packs: [PackModel]
    @Query(sort: \TemplateModel.createdAt) private var templates: [TemplateModel]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    templateChips
                    section(title: "Pinned", packs: filteredPacks.filter { $0.pinned })
                    section(title: "In Progress", packs: filteredPacks.filter { !$0.pinned && !$0.items.allSatisfy { $0.isPacked } })
                    section(title: "Recent", packs: filteredPacks)
                }
                .padding()
            }
            .searchable(text: $searchText)
            .navigationTitle("Packs")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewPack = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewPack) {
                NewPackView(onCreated: { pack in
                    showingNewPack = false
                })
                .modelContainer(context.container)
            }
        }
    }

    private var filteredPacks: [PackModel] {
        if searchText.isEmpty { return packs }
        return packs.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stay ahead of every pack")
                .font(.largeTitle.bold())
            Text("Pin essentials, reuse templates, and finish packing faster.")
                .foregroundStyle(AppTheme.secondary(scheme))
        }
    }

    private var templateChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(templates.prefix(6)) { template in
                    Button {
                        createPack(from: template)
                    } label: {
                        Label(template.name, systemImage: template.typeTag.icon)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(AppTheme.surface(scheme))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func section(title: String, packs: [PackModel]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.title3.bold())
                Spacer()
            }
            ForEach(packs) { pack in
                NavigationLink(value: pack) {
                    packRow(pack)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationDestination(for: PackModel.self) { pack in
            PackDetailView(pack: pack)
        }
    }

    private func packRow(_ pack: PackModel) -> some View {
        HStack(spacing: 12) {
            ProgressRing(progress: pack.completionPercentage)
            VStack(alignment: .leading, spacing: 6) {
                Text(pack.name)
                    .font(.headline)
                if let when = pack.when {
                    Label(DateFormatter.short.string(from: when), systemImage: "calendar")
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondary(scheme))
                }
                Text("\(pack.items.filter { !$0.isPacked }.count) left")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondary(scheme))
            }
            Spacer()
            Image(systemName: pack.typeTag.icon)
                .foregroundStyle(AppTheme.accent(scheme))
        }
        .padding()
        .background(AppTheme.surface(scheme))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.separator(scheme), lineWidth: 1)
        )
    }

    private func createPack(from template: TemplateModel) {
        let pack = PackModel(name: template.name, typeTag: template.typeTag, template: template)
        pack.items = template.items.map { item in
            PackItemModel(title: item.title, note: item.note, quantity: item.quantity, category: item.category, isEssential: item.isEssential, templateItem: item)
        }
        context.insert(pack)
        try? context.save()
    }
}
