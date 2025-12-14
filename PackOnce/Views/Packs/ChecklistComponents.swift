import SwiftUI

struct ChecklistRow: View {
    @Binding var item: PackItemModel
    var moveToBottom: Bool
    var collapsePacked: Bool
    var onEdit: () -> Void
    var onDelete: () -> Void
    var onPinEssential: () -> Void

    @Environment(\.colorScheme) private var scheme
    @Environment(\._largeTextEnabled) private var largeTextEnabled
    @State private var showTemplatePrompt = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Button(action: togglePacked) {
                    Image(systemName: item.isPacked ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(item.isPacked ? AppTheme.accent(scheme) : AppTheme.secondary(scheme))
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(item.title)
                            .font(.headline)
                            .foregroundStyle(AppTheme.text(scheme))
                        if item.isEssential {
                            Text("Pinned")
                                .pillChip(background: AppTheme.accent(scheme).opacity(0.14), foreground: AppTheme.accent(scheme))
                        }
                    }
                    if !item.note.isEmpty {
                        Text(item.note)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.secondary(scheme))
                    }
                    Text("Qty: \(item.quantity)")
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondary(scheme))
                }
                Spacer()
                Stepper("", value: $item.quantity, in: 1...20)
                    .labelsHidden()
            }
            .contentShape(Rectangle())
            .swipeActions(edge: .trailing) {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                }
                Button(action: onPinEssential) {
                    Label(item.isEssential ? "Unpin" : "Pin", systemImage: "pin")
                }
            }
        }
    }

    private func togglePacked() {
        item.isPacked.toggle()
    }
}
