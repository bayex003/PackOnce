import SwiftUI

struct SettingToggleRow: View {
    var title: String
    var description: String
    @Binding var isOn: Bool
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.text(scheme))
                Spacer()
                Toggle("", isOn: $isOn)
                    .labelsHidden()
            }
            Text(description)
                .font(.caption)
                .foregroundStyle(AppTheme.secondary(scheme))
        }
        .padding()
        .background(AppTheme.surface(scheme))
        .cornerRadius(16)
    }
}
