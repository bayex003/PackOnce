import SwiftUI
import SwiftData

struct NewPackView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(sort: \TemplateModel.createdAt) private var templates: [TemplateModel]

    @State private var name: String = ""
    @State private var when: Date = .now
    @State private var typeTag: TypeTag = .travel
    @State private var useDate = false
    @State private var selectedTemplate: TemplateModel?

    var onCreated: (PackModel) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Pack name", text: $name)
                    Toggle("Set a date", isOn: $useDate)
                    if useDate {
                        DatePicker("When", selection: $when, displayedComponents: [.date, .hourAndMinute])
                    }
                    Picker("Type", selection: $typeTag) {
                        ForEach(TypeTag.allCases) { tag in
                            Label(tag.rawValue, systemImage: tag.icon).tag(tag)
                        }
                    }
                }

                Section("Templates") {
                    Picker("Start from", selection: $selectedTemplate) {
                        Text("Blank").tag(TemplateModel?.none)
                        ForEach(templates) { template in
                            Text(template.name).tag(TemplateModel?.some(template))
                        }
                    }
                }
            }
            .navigationTitle("New Pack")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create", action: create)
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func create() {
        let pack = PackModel(name: name, when: useDate ? when : nil, typeTag: typeTag, template: selectedTemplate)
        if let template = selectedTemplate {
            pack.items = template.items.map { item in
                PackItemModel(title: item.title, note: item.note, quantity: item.quantity, category: item.category, isEssential: item.isEssential, templateItem: item)
            }
        }
        context.insert(pack)
        try? context.save()
        onCreated(pack)
        dismiss()
    }
}
