import SwiftUI
import SwiftData

struct PackDetailView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) private var scheme
    @Environment(\._largeTextEnabled) private var largeText
    @EnvironmentObject private var paywallState: PaywallState
    @EnvironmentObject private var storeKit: StoreKitService
    @AppStorage("moveCheckedToBottom") private var moveCheckedToBottom = true
    @AppStorage("collapsePacked") private var collapsePacked = true
    @State var pack: PackModel
    @State private var newItemTitle: String = ""
    @State private var newItemCategory: String = "Quick"
    @State private var showShare = false
    @State private var showPDFExport = false
    @State private var pdfData: Data?
    @State private var showTemplateUpdate = false
    @State private var editingItem: PackItemModel?

    var body: some View {
        List {
            header
            prompts
            ForEach(Array(pack.categories.keys).sorted(), id: \.self) { category in
                Section(header: sectionHeader(title: category)) {
                    let items = pack.categories[category] ?? []
                    ForEach(items) { item in
                        ChecklistRow(
                            item: binding(for: item),
                            moveToBottom: moveCheckedToBottom,
                            collapsePacked: collapsePacked,
                            onEdit: { editingItem = item },
                            onDelete: { delete(item) },
                            onPinEssential: { togglePin(item) }
                        )
                        .opacity(item.isPacked && collapsePacked ? 0.4 : 1)
                    }
                }
            }
            quickAddBar
        }
        .listStyle(.insetGrouped)
        .navigationTitle(pack.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: shareText) { Image(systemName: "square.and.arrow.up") }
                Button(action: exportPDF) { Image(systemName: "doc.richtext") }
            }
        }
        .sheet(isPresented: $showShare) {
            if let data = pdfData, showPDFExport {
                ShareSheet(activityItems: [data])
            } else {
                ShareSheet(activityItems: [ExportService.shareText(for: pack)])
            }
        }
        .onChange(of: pack.items) { _, _ in
            pack.lastOpened = .now
            try? context.save()
        }
        .sheet(item: $editingItem) { item in
            EditPackItemView(item: binding(for: item), template: pack.template) {
                try? context.save()
            }
        }
    }

    private var header: some View {
        HStack(spacing: 16) {
            ProgressRing(progress: pack.completionPercentage)
            VStack(alignment: .leading, spacing: 6) {
                Text(pack.name)
                    .font(.title2.bold())
                if let when = pack.when {
                    Label(DateFormatter.short.string(from: when), systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondary(scheme))
                }
                Text("\(pack.items.filter { !$0.isPacked }.count) items left")
                    .foregroundStyle(AppTheme.secondary(scheme))
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }

    private var prompts: some View {
        let suggestions = DontForgetPrompter.prompts(for: pack)
        return Group {
            if !suggestions.isEmpty {
                Section("Don't forget") {
                    ForEach(suggestions, id: \.self) { suggestion in
                        HStack {
                            Text(suggestion)
                            Spacer()
                            Button("Add") { addSuggestion(suggestion) }
                        }
                    }
                    Button("Add all") {
                        suggestions.forEach(addSuggestion)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
    }

    private var quickAddBar: some View {
        HStack {
            TextField("Add item", text: $newItemTitle)
            TextField("Category", text: $newItemCategory)
                .frame(width: 120)
            Button("Add") { addItem() }
                .buttonStyle(AccentButtonStyle())
        }
    }

    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
            Spacer()
            if collapsePacked {
                Text("Packed hidden")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondary(scheme))
            }
        }
    }

    private func binding(for item: PackItemModel) -> Binding<PackItemModel> {
        guard let index = pack.items.firstIndex(where: { $0.id == item.id }) else {
            fatalError("Missing pack item")
        }
        return $pack.items[index]
    }

    private func addItem() {
        guard !newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let item = PackItemModel(title: newItemTitle, category: newItemCategory)
        if let when = pack.when, abs(when.timeIntervalSinceNow) < 24 * 60 * 60 {
            item.note = "Added last-minute"
        }
        pack.items.append(item)
        newItemTitle = ""
        try? context.save()
    }

    private func delete(_ item: PackItemModel) {
        if item.templateItem != nil {
            showTemplateUpdate = true
        }
        if let index = pack.items.firstIndex(where: { $0.id == item.id }) {
            pack.items.remove(at: index)
        }
        try? context.save()
    }

    private func togglePin(_ item: PackItemModel) {
        if let index = pack.items.firstIndex(where: { $0.id == item.id }) {
            pack.items[index].isEssential.toggle()
        }
    }

    private func shareText() {
        showPDFExport = false
        showShare = true
    }

    private func exportPDF() {
        if storeKit.isProUnlocked(debugOverride: paywallState.debugProUnlocked) {
            pdfData = ExportService.renderPDF(for: pack)
            showPDFExport = true
            showShare = true
        } else {
            paywallState.isPresented = true
        }
    }

    private func addSuggestion(_ title: String) {
        let item = PackItemModel(title: title, category: "Reminders", isEssential: true)
        pack.items.append(item)
    }
}

struct EditPackItemView: View {
    @Binding var item: PackItemModel
    var template: TemplateModel?
    var onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showTemplateSheet = false

    var body: some View {
        NavigationStack {
            Form {
                TextField("Item", text: $item.title)
                TextField("Note", text: $item.note)
                Stepper("Quantity: \(item.quantity)", value: $item.quantity, in: 1...20)
                Toggle("Essential", isOn: $item.isEssential)
            }
            .navigationTitle("Edit item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if item.templateItem != nil { showTemplateSheet = true } else { finish() }
                    }
                }
            }
            .confirmationDialog("Apply changes to template?", isPresented: $showTemplateSheet) {
                Button("Change for this pack only", role: .cancel) { finish() }
                if let template = template {
                    Button("Update template too") { updateTemplate(template) }
                }
            }
        }
    }

    private func finish() {
        onSave()
        dismiss()
    }

    private func updateTemplate(_ template: TemplateModel) {
        if let linked = item.templateItem, let index = template.items.firstIndex(where: { $0.id == linked.id }) {
            template.items[index].title = item.title
            template.items[index].note = item.note
            template.items[index].quantity = item.quantity
            template.items[index].isEssential = item.isEssential
        }
        finish()
    }
}

enum DontForgetPrompter {
    static func prompts(for pack: PackModel) -> [String] {
        var prompts: [String] = []
        if pack.typeTag == .travel { prompts.append("Passport") }
        if pack.typeTag == .gym { prompts.append("Towel") }
        if pack.when != nil { prompts.append("Chargers") }
        if pack.items.filter({ $0.isEssential }).isEmpty { prompts.append("Mark essentials") }
        return Array(Set(prompts))
    }
}
