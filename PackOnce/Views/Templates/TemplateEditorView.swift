import SwiftUI
import SwiftData

struct TemplateEditorView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    @State var template: TemplateModel
    @State private var newCategory = ""
    @State private var newItemTitle = ""
    @State private var newItemNote = ""
    @State private var newItemQuantity = 1
    @State private var newItemCategory = "General"

    var body: some View {
        Form {
            Section("Details") {
                TextField("Name", text: $template.name)
                Picker("Type", selection: $template.typeTag) {
                    ForEach(TypeTag.allCases) { tag in
                        Text(tag.rawValue).tag(tag)
                    }
                }
            }

            Section("Items") {
                ForEach(template.items) { item in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.title)
                            Spacer()
                            Stepper("Qty: \(item.quantity)", value: binding(for: item).quantity, in: 1...20)
                                .labelsHidden()
                        }
                        if !item.note.isEmpty {
                            Text(item.note)
                                .font(.caption)
                        }
                        Text(item.category)
                            .font(.caption2)
                            .foregroundStyle(AppTheme.secondary(scheme))
                    }
                }
                .onDelete(perform: delete)

                VStack(alignment: .leading) {
                    TextField("Item name", text: $newItemTitle)
                    TextField("Note", text: $newItemNote)
                    Stepper("Quantity: \(newItemQuantity)", value: $newItemQuantity, in: 1...20)
                    TextField("Category", text: $newItemCategory)
                    Button("Add item", action: addItem)
                }
            }

            Section {
                Button("Use Template") {
                    createPackFromTemplate()
                }
                .buttonStyle(AccentButtonStyle())
            }
        }
        .navigationTitle(template.name)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close", action: dismiss.callAsFunction)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    try? context.save()
                    dismiss()
                }
            }
        }
    }

    private func binding(for item: TemplateItemModel) -> Binding<TemplateItemModel> {
        guard let index = template.items.firstIndex(where: { $0.id == item.id }) else {
            fatalError("Missing template item")
        }
        return $template.items[index]
    }

    private func addItem() {
        guard !newItemTitle.isEmpty else { return }
        let item = TemplateItemModel(title: newItemTitle, note: newItemNote, quantity: newItemQuantity, category: newItemCategory)
        template.items.append(item)
        newItemTitle = ""
        newItemNote = ""
        newItemQuantity = 1
    }

    private func delete(at offsets: IndexSet) {
        template.items.remove(atOffsets: offsets)
    }

    private func createPackFromTemplate() {
        let pack = PackModel(name: template.name, typeTag: template.typeTag, template: template)
        pack.items = template.items.map { item in
            PackItemModel(title: item.title, note: item.note, quantity: item.quantity, category: item.category, isEssential: item.isEssential, templateItem: item)
        }
        context.insert(pack)
        try? context.save()
    }
}
