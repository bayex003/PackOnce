import SwiftUI

struct PackDetailView: View {
    struct PackDetailItem: Identifiable {
        let id = UUID()
        let name: String
        let quantity: Int
        let note: String?
        var isPacked: Bool
    }

    struct PackDetailSection: Identifiable {
        let id = UUID()
        let title: String
        let isPinned: Bool
        let isLastMinute: Bool
        var items: [PackDetailItem]
    }

    enum PackFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case toPack = "To Pack"
        case packed = "Packed"

        var id: String { rawValue }
    }

    let packName: String
    @State private var selectedFilter: PackFilter = .all
    @State private var moveCheckedToBottom: Bool = true
    @State private var addItemText: String = ""
    @State private var sections: [PackDetailSection] = [
        PackDetailSection(
            title: "Essentials (Pinned)",
            isPinned: true,
            isLastMinute: false,
            items: [
                PackDetailItem(name: "Passport", quantity: 1, note: "In top drawer", isPacked: false),
                PackDetailItem(name: "Charger & Adapter", quantity: 1, note: nil, isPacked: false)
            ]
        ),
        PackDetailSection(
            title: "Last-Minute",
            isPinned: false,
            isLastMinute: true,
            items: [
                PackDetailItem(name: "Toothbrush", quantity: 1, note: "Still wet, pack last", isPacked: false)
            ]
        ),
        PackDetailSection(
            title: "Clothing",
            isPinned: false,
            isLastMinute: false,
            items: [
                PackDetailItem(name: "T-Shirts", quantity: 5, note: nil, isPacked: true),
                PackDetailItem(name: "Socks", quantity: 7, note: nil, isPacked: false),
                PackDetailItem(name: "Swimwear", quantity: 2, note: nil, isPacked: false)
            ]
        ),
        PackDetailSection(
            title: "Toiletries",
            isPinned: false,
            isLastMinute: false,
            items: [
                PackDetailItem(name: "Sunscreen", quantity: 1, note: nil, isPacked: true),
                PackDetailItem(name: "Razor", quantity: 1, note: nil, isPacked: true),
                PackDetailItem(name: "Skincare kit", quantity: 1, note: nil, isPacked: false)
            ]
        ),
        PackDetailSection(
            title: "Tech",
            isPinned: false,
            isLastMinute: false,
            items: [
                PackDetailItem(name: "Camera", quantity: 2, note: "Charge battery", isPacked: true),
                PackDetailItem(name: "Earbuds", quantity: 2, note: nil, isPacked: false),
                PackDetailItem(name: "Power bank", quantity: 2, note: nil, isPacked: false),
                PackDetailItem(name: "E-reader", quantity: 2, note: nil, isPacked: true)
            ]
        ),
        PackDetailSection(
            title: "Extras",
            isPinned: false,
            isLastMinute: false,
            items: [
                PackDetailItem(name: "Travel journal", quantity: 2, note: nil, isPacked: true),
                PackDetailItem(name: "Reusable bag", quantity: 3, note: nil, isPacked: true),
                PackDetailItem(name: "Snacks", quantity: 4, note: "Flight friendly", isPacked: false),
                PackDetailItem(name: "Compact umbrella", quantity: 2, note: nil, isPacked: true),
                PackDetailItem(name: "Guidebook", quantity: 3, note: nil, isPacked: false)
            ]
        )
    ]

    @Environment(\.dismiss) private var dismiss

    private var packedTotals: (packed: Int, total: Int) {
        let totals = sections.flatMap(\.items).reduce(into: (packed: 0, total: 0)) { result, item in
            result.total += item.quantity
            if item.isPacked {
                result.packed += item.quantity
            }
        }
        return totals
    }

    private var progressValue: Double {
        guard packedTotals.total > 0 else { return 0 }
        return Double(packedTotals.packed) / Double(packedTotals.total)
    }

    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    header
                    progressSection
                    filterSection
                    sectionsList
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.top, AppTheme.Spacing.xl)
                .padding(.bottom, AppTheme.Spacing.xxl)
            }
        }
        .safeAreaInset(edge: .bottom) {
            addItemBar
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle().fill(AppTheme.Colors.surface.opacity(0.6))
                    )
            }
            .buttonStyle(.plain)

            Spacer()

            Text(packName)
                .font(AppTheme.Typography.headline())
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Spacer()

            Button {} label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle().fill(AppTheme.Colors.surface.opacity(0.6))
                    )
            }
            .buttonStyle(.plain)
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text("\(packedTotals.packed) / \(packedTotals.total) items packed")
                    .font(AppTheme.Typography.callout())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                Spacer()
                Text("\(Int(progressValue * 100))%")
                    .font(AppTheme.Typography.callout())
                    .foregroundStyle(AppTheme.Colors.primary)
            }

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppTheme.Colors.surfaceElevated)
                    .frame(height: 8)
                Capsule()
                    .fill(AppTheme.Colors.primary)
                    .frame(height: 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scaleEffect(x: CGFloat(max(progressValue, 0.02)), y: 1, anchor: .leading)
            }
        }
    }

    private var filterSection: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ForEach(PackFilter.allCases) { filter in
                Button {
                    selectedFilter = filter
                } label: {
                    Text(filter.rawValue)
                        .font(AppTheme.Typography.callout())
                        .foregroundStyle(selectedFilter == filter ? AppTheme.Colors.textPrimary : AppTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                                .fill(selectedFilter == filter ? AppTheme.Colors.surface : AppTheme.Colors.surfaceElevated)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                .fill(AppTheme.Colors.surface.opacity(0.65))
        )
    }

    private var sectionsList: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            ForEach(sections.indices, id: \.self) { sectionIndex in
                let section = sections[sectionIndex]
                let visibleItems = visibleItems(for: section)

                if !visibleItems.isEmpty {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        if section.isLastMinute {
                            lastMinuteCard(items: visibleItems, sectionIndex: sectionIndex)
                        } else {
                            sectionHeader(for: section)

                            VStack(spacing: 0) {
                                ForEach(visibleItems) { item in
                                    checklistRow(item: item, sectionIndex: sectionIndex)

                                    if item.id != visibleItems.last?.id {
                                        Divider()
                                            .background(AppTheme.Colors.surfaceBorder)
                                            .padding(.leading, 48)
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                                    .fill(AppTheme.Colors.surface.opacity(0.4))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                                            .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                                    )
                            )
                        }
                    }
                }
            }
        }
    }

    private func sectionHeader(for section: PackDetailSection) -> some View {
        HStack {
            Text(section.title)
                .font(AppTheme.Typography.headline())
                .foregroundStyle(AppTheme.Colors.textPrimary)
            Spacer()
            if section.isPinned {
                Image(systemName: "pin.fill")
                    .foregroundStyle(AppTheme.Colors.warning)
            }
        }
    }

    private func lastMinuteCard(items: [PackDetailItem], sectionIndex: Int) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "clock.fill")
                    .foregroundStyle(AppTheme.Colors.warning)
                Text("LAST-MINUTE")
                    .font(AppTheme.Typography.callout())
                    .foregroundStyle(AppTheme.Colors.warning)
            }

            VStack(spacing: 0) {
                ForEach(items) { item in
                    checklistRow(item: item, sectionIndex: sectionIndex, usesWarningStyle: true)

                    if item.id != items.last?.id {
                        Divider()
                            .background(AppTheme.Colors.warning.opacity(0.4))
                            .padding(.leading, 48)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                .fill(AppTheme.Colors.warning.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                        .foregroundStyle(AppTheme.Colors.warning.opacity(0.6))
                )
        )
    }

    private func checklistRow(item: PackDetailItem, sectionIndex: Int, usesWarningStyle: Bool = false) -> some View {
        Button {
            toggleItem(sectionIndex: sectionIndex, itemID: item.id)
        } label: {
            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(usesWarningStyle ? AppTheme.Colors.warning : AppTheme.Colors.primaryMuted, lineWidth: 2)
                        .frame(width: 24, height: 24)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(item.isPacked ? AppTheme.Colors.primary : Color.clear)
                        )
                    if item.isPacked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.black)
                    }
                }

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(item.name)
                        .font(AppTheme.Typography.body())
                        .foregroundStyle(AppTheme.Colors.textPrimary.opacity(item.isPacked ? 0.5 : 1))
                        .strikethrough(item.isPacked, color: AppTheme.Colors.textSecondary)
                    if let subtitle = subtitleText(for: item) {
                        Text(subtitle)
                            .font(AppTheme.Typography.caption())
                            .foregroundStyle(usesWarningStyle ? AppTheme.Colors.warning : AppTheme.Colors.textSecondary)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
        }
        .buttonStyle(.plain)
    }

    private var addItemBar: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            TextField("Add item…", text: $addItemText)
                .font(AppTheme.Typography.body())
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.md)
                .background(
                    Capsule().fill(AppTheme.Colors.surface)
                )

            Button {
                addItemText = ""
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(width: 52, height: 52)
                    .background(
                        Circle().fill(AppTheme.Colors.primary)
                    )
                    .applyShadow(AppTheme.Shadows.glow)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.top, AppTheme.Spacing.sm)
        .padding(.bottom, AppTheme.Spacing.lg)
        .background(
            AppTheme.Colors.backgroundBottom.opacity(0.92)
                .ignoresSafeArea()
        )
    }

    private func subtitleText(for item: PackDetailItem) -> String? {
        var parts: [String] = ["Qty: \(item.quantity)"]
        if let note = item.note, !note.isEmpty {
            parts.append(note)
        }
        return parts.joined(separator: " • ")
    }

    private func visibleItems(for section: PackDetailSection) -> [PackDetailItem] {
        var items = section.items
        switch selectedFilter {
        case .all:
            break
        case .toPack:
            items = items.filter { !$0.isPacked }
        case .packed:
            items = items.filter { $0.isPacked }
        }

        if moveCheckedToBottom {
            items.sort { lhs, rhs in
                if lhs.isPacked == rhs.isPacked {
                    return lhs.name < rhs.name
                }
                return !lhs.isPacked && rhs.isPacked
            }
        }
        return items
    }

    private func toggleItem(sectionIndex: Int, itemID: UUID) {
        guard sections.indices.contains(sectionIndex) else { return }
        if let itemIndex = sections[sectionIndex].items.firstIndex(where: { $0.id == itemID }) {
            sections[sectionIndex].items[itemIndex].isPacked.toggle()
        }
    }
}

#Preview {
    NavigationStack {
        PackDetailView(packName: "Europe Summer '24")
    }
}
