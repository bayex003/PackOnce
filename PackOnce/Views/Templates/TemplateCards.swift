import SwiftUI

struct TemplateCard: View {
    var template: TemplateModel
    var locked: Bool
    var action: () -> Void
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: template.typeTag.icon)
                    .foregroundStyle(AppTheme.accent(scheme))
                Text(template.name)
                    .font(.headline)
                Spacer()
                if locked {
                    Image(systemName: "lock")
                        .foregroundStyle(AppTheme.secondary(scheme))
                }
            }
            Text(template.typeTag.rawValue)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondary(scheme))
            if template.items.isEmpty {
                Text("Preview available in Pro")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondary(scheme))
            } else {
                Text("\(template.items.count) items ready")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondary(scheme))
            }
        }
        .padding()
        .background(AppTheme.surface(scheme))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppTheme.separator(scheme), lineWidth: 1)
        )
        .onTapGesture { action() }
    }
}
