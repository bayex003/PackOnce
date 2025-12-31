import SwiftUI
import UIKit

struct PackDetailView: View {
    struct PackDetailItem: Identifiable {
        let id = UUID()
        let name: String
        var quantity: Int
        var category: String
        var note: String
        var isPacked: Bool
        let templateItemID: UUID?
    }

    struct PackDetailSection: Identifiable {
        let id = UUID()
        let title: String
        let isPinned: Bool
        let isLastMinute: Bool
        var items: [PackDetailItem]
    }

    struct TemplateItem: Identifiable {
        let id: UUID
        let name: String
        var quantity: Int
        var category: String
        var note: String
    }

    enum PackFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case toPack = "To Pack"
        case packed = "Packed"

        var id: String { rawValue }
    }

    let packName: String
    @ObservedObject var purchaseManager: PurchaseManager
    @Binding var exportPreference: ExportPreference
    private static let templateSeedItems: [TemplateItem] = [
        TemplateItem(id: UUID(), name: "Passport", quantity: 1, category: "Essentials", note: "In top drawer"),
        TemplateItem(id: UUID(), name: "Charger & Adapter", quantity: 1, category: "Tech", note: ""),
        TemplateItem(id: UUID(), name: "T-Shirts", quantity: 5, category: "Clothes", note: ""),
        TemplateItem(id: UUID(), name: "Socks", quantity: 7, category: "Clothes", note: "")
    ]

    @State private var selectedFilter: PackFilter = .all
    @State private var moveCheckedToBottom: Bool = true
    @State private var addItemText: String = ""
    @State private var editSelection: EditItemSelection?
    @State private var showingShareSheet = false
    @State private var shareItems: [Any] = []
    @State private var showingPaywall = false
    @State private var templateItems: [TemplateItem] = Self.templateSeedItems
    @State private var sections: [PackDetailSection] = [
        PackDetailSection(
            title: "Essentials (Pinned)",
            isPinned: true,
            isLastMinute: false,
            items: [
                PackDetailItem(
                    name: "Passport",
                    quantity: 1,
                    category: "Essentials",
                    note: "In top drawer",
                    isPacked: false,
                    templateItemID: PackDetailView.templateSeedItems[0].id
                ),
                PackDetailItem(
                    name: "Charger & Adapter",
                    quantity: 1,
                    category: "Tech",
                    note: "",
                    isPacked: false,
                    templateItemID: PackDetailView.templateSeedItems[1].id
                )
            ]
        ),
        PackDetailSection(
            title: "Last-Minute",
            isPinned: false,
            isLastMinute: true,
            items: [
                PackDetailItem(
                    name: "Toothbrush",
                    quantity: 1,
                    category: "Toiletries",
                    note: "Still wet, pack last",
                    isPacked: false,
                    templateItemID: nil
                )
            ]
        ),
        PackDetailSection(
            title: "Clothing",
            isPinned: false,
            isLastMinute: false,
            items: [
                PackDetailItem(
                    name: "T-Shirts",
                    quantity: 5,
                    category: "Clothes",
                    note: "",
                    isPacked: true,
                    templateItemID: PackDetailView.templateSeedItems[2].id
                ),
                PackDetailItem(
                    name: "Socks",
                    quantity: 7,
                    category: "Clothes",
                    note: "",
                    isPacked: false,
                    templateItemID: PackDetailView.templateSeedItems[3].id
                ),
                PackDetailItem(
                    name: "Swimwear",
                    quantity: 2,
                    category: "Clothes",
                    note: "",
                    isPacked: false,
                    templateItemID: nil
                )
            ]
        ),
        PackDetailSection(
            title: "Toiletries",
            isPinned: false,
            isLastMinute: false,
            items: [
                PackDetailItem(
                    name: "Sunscreen",
                    quantity: 1,
                    category: "Toiletries",
                    note: "",
                    isPacked: true,
                    templateItemID: nil
                ),
                PackDetailItem(
                    name: "Razor",
                    quantity: 1,
                    category: "Toiletries",
                    note: "",
                    isPacked: true,
                    templateItemID: nil
                ),
                PackDetailItem(
                    name: "Skincare kit",
                    quantity: 1,
                    category: "Toiletries",
                    note: "",
                    isPacked: false,
                    templateItemID: nil
                )
            ]
        ),
        PackDetailSection(
            title: "Tech",
            isPinned: false,
            isLastMinute: false,
            items: [
                PackDetailItem(
                    name: "Camera",
                    quantity: 2,
                    category: "Tech",
                    note: "Charge battery",
                    isPacked: true,
                    templateItemID: nil
                ),
                PackDetailItem(
                    name: "Earbuds",
                    quantity: 2,
                    category: "Tech",
                    note: "",
                    isPacked: false,
                    templateItemID: nil
                ),
                PackDetailItem(
                    name: "Power bank",
                    quantity: 2,
                    category: "Tech",
                    note: "",
                    isPacked: false,
                    templateItemID: nil
                ),
                PackDetailItem(
                    name: "E-reader",
                    quantity: 2,
                    category: "Tech",
                    note: "",
                    isPacked: true,
                    templateItemID: nil
                )
            ]
        ),
        PackDetailSection(
            title: "Extras",
            isPinned: false,
            isLastMinute: false,
            items: [
                PackDetailItem(
                    name: "Travel journal",
                    quantity: 2,
                    category: "Extras",
                    note: "",
                    isPacked: true,
                    templateItemID: nil
                ),
                PackDetailItem(
                    name: "Reusable bag",
                    quantity: 3,
                    category: "Extras",
                    note: "",
                    isPacked: true,
                    templateItemID: nil
                ),
                PackDetailItem(
                    name: "Snacks",
                    quantity: 4,
                    category: "Extras",
                    note: "Flight friendly",
                    isPacked: false,
                    templateItemID: nil
                ),
                PackDetailItem(
                    name: "Compact umbrella",
                    quantity: 2,
                    category: "Extras",
                    note: "",
                    isPacked: true,
                    templateItemID: nil
                ),
                PackDetailItem(
                    name: "Guidebook",
                    quantity: 3,
                    category: "Extras",
                    note: "",
                    isPacked: false,
                    templateItemID: nil
                )
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
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: shareItems)
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallStubView()
        }
        .sheet(item: $editSelection) { selection in
            if let item = itemForSelection(selection) {
                EditItemView(
                    itemName: item.name,
                    quantity: item.quantity,
                    category: item.category,
                    notes: item.note,
                    showsTemplateOption: item.templateItemID != nil,
                    onCancel: {
                        editSelection = nil
                    },
                    onSave: { updatedQuantity, updatedCategory, updatedNotes, applyToTemplate in
                        updateItem(
                            selection: selection,
                            quantity: updatedQuantity,
                            category: updatedCategory,
                            note: updatedNotes,
                            applyToTemplate: applyToTemplate
                        )
                        editSelection = nil
                    },
                    onDelete: {
                        deleteItem(selection: selection)
                        editSelection = nil
                    }
                )
            }
        }
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

            Menu {
                Button {
                    shareAsText()
                } label: {
                    Label("Share as Text", systemImage: exportPreference == .text ? "checkmark" : "text.alignleft")
                }
                Button {
                    exportPDF()
                } label: {
                    Label("Export PDF", systemImage: exportPreference == .pdf ? "checkmark" : "doc.richtext")
                }
            } label: {
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
            .contentShape(Rectangle())
            .highPriorityGesture(
                TapGesture().onEnded {
                    toggleItem(sectionIndex: sectionIndex, itemID: item.id)
                }
            )

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
        .contentShape(Rectangle())
        .onTapGesture {
            editSelection = EditItemSelection(sectionIndex: sectionIndex, itemID: item.id)
        }
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
        if !item.note.isEmpty {
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

    private func itemForSelection(_ selection: EditItemSelection) -> PackDetailItem? {
        guard sections.indices.contains(selection.sectionIndex) else { return nil }
        return sections[selection.sectionIndex].items.first { $0.id == selection.itemID }
    }

    private func updateItem(
        selection: EditItemSelection,
        quantity: Int,
        category: String,
        note: String,
        applyToTemplate: Bool
    ) {
        guard sections.indices.contains(selection.sectionIndex) else { return }
        if let itemIndex = sections[selection.sectionIndex].items.firstIndex(where: { $0.id == selection.itemID }) {
            sections[selection.sectionIndex].items[itemIndex].quantity = quantity
            sections[selection.sectionIndex].items[itemIndex].category = category
            sections[selection.sectionIndex].items[itemIndex].note = note
            if applyToTemplate, let templateID = sections[selection.sectionIndex].items[itemIndex].templateItemID {
                updateTemplateItem(templateID: templateID, quantity: quantity, category: category, note: note)
            }
        }
    }

    private func updateTemplateItem(templateID: UUID, quantity: Int, category: String, note: String) {
        if let templateIndex = templateItems.firstIndex(where: { $0.id == templateID }) {
            templateItems[templateIndex].quantity = quantity
            templateItems[templateIndex].category = category
            templateItems[templateIndex].note = note
        }
    }

    private func deleteItem(selection: EditItemSelection) {
        guard sections.indices.contains(selection.sectionIndex) else { return }
        sections[selection.sectionIndex].items.removeAll { $0.id == selection.itemID }
    }

    private func shareAsText() {
        shareItems = [textChecklist()]
        showingShareSheet = true
    }

    private func exportPDF() {
        guard purchaseManager.isProActive else {
            showingPaywall = true
            return
        }
        let pdfData = makePDFData()
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(pdfFileName())
        do {
            try pdfData.write(to: fileURL, options: .atomic)
            shareItems = [fileURL]
            showingShareSheet = true
        } catch {
            shareItems = [textChecklist()]
            showingShareSheet = true
        }
    }

    private func textChecklist() -> String {
        var lines: [String] = ["\(packName) Checklist", ""]
        for section in sections {
            lines.append(section.title)
            for item in section.items {
                let status = item.isPacked ? "[x]" : "[ ]"
                var line = "\(status) \(item.name) (x\(item.quantity))"
                if !item.note.isEmpty {
                    line += " — \(item.note)"
                }
                lines.append(line)
            }
            lines.append("")
        }
        return lines.joined(separator: "\n")
    }

    private func pdfFileName() -> String {
        let safeName = packName.replacingOccurrences(of: "/", with: "-")
        let baseName = safeName.trimmingCharacters(in: .whitespacesAndNewlines)
        return "\(baseName.isEmpty ? "PackOnce" : baseName).pdf"
    }

    private func makePDFData() -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let margin: CGFloat = 48
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        return renderer.pdfData { context in
            context.beginPage()
            var yPosition = margin
            let titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
            let sectionFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
            let bodyFont = UIFont.systemFont(ofSize: 12, weight: .regular)
            let titleColor = UIColor.label
            let bodyColor = UIColor.secondaryLabel

            yPosition = drawText(
                packName,
                font: titleFont,
                color: titleColor,
                at: yPosition,
                context: context,
                pageRect: pageRect,
                margin: margin
            )
            yPosition += 12

            for section in sections {
                yPosition = drawText(
                    section.title,
                    font: sectionFont,
                    color: titleColor,
                    at: yPosition,
                    context: context,
                    pageRect: pageRect,
                    margin: margin
                )
                yPosition += 6

                for item in section.items {
                    let status = item.isPacked ? "✓" : "○"
                    var line = "\(status) \(item.name) (x\(item.quantity))"
                    if !item.note.isEmpty {
                        line += " — \(item.note)"
                    }
                    yPosition = drawText(
                        line,
                        font: bodyFont,
                        color: bodyColor,
                        at: yPosition,
                        context: context,
                        pageRect: pageRect,
                        margin: margin
                    )
                }
                yPosition += 10
            }
        }
    }

    private func drawText(
        _ text: String,
        font: UIFont,
        color: UIColor,
        at yPosition: CGFloat,
        context: UIGraphicsPDFRendererContext,
        pageRect: CGRect,
        margin: CGFloat
    ) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
        let maxWidth = pageRect.width - (margin * 2)
        let boundingRect = (text as NSString).boundingRect(
            with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )

        if yPosition + boundingRect.height > pageRect.height - margin {
            context.beginPage()
            return drawText(
                text,
                font: font,
                color: color,
                at: margin,
                context: context,
                pageRect: pageRect,
                margin: margin
            )
        }

        let drawRect = CGRect(x: margin, y: yPosition, width: maxWidth, height: boundingRect.height)
        (text as NSString).draw(in: drawRect, withAttributes: attributes)
        return yPosition + boundingRect.height + 4
    }
}

private struct PaywallStubView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppBackgroundView()
            VStack(spacing: AppTheme.Spacing.lg) {
                Text("PackOnce Pro")
                    .font(AppTheme.Typography.title())
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                Text("Unlock PDF exports and more with Pro.")
                    .font(AppTheme.Typography.body())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                PrimaryCTAButton(title: "Close") {
                    dismiss()
                }
            }
            .padding(AppTheme.Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                    .fill(AppTheme.Colors.surface)
            )
            .padding(AppTheme.Spacing.xl)
        }
    }
}

private struct EditItemSelection: Identifiable {
    let id = UUID()
    let sectionIndex: Int
    let itemID: UUID
}

private struct EditItemView: View {
    private struct CategoryOption: Identifiable {
        let id = UUID()
        let name: String
        let icon: String
    }

    private let categoryOptions: [CategoryOption] = [
        CategoryOption(name: "Clothes", icon: "hanger"),
        CategoryOption(name: "Tech", icon: "laptopcomputer"),
        CategoryOption(name: "Toiletries", icon: "drop.fill"),
        CategoryOption(name: "Essentials", icon: "star.fill"),
        CategoryOption(name: "Extras", icon: "sparkles")
    ]

    let itemName: String
    let showsTemplateOption: Bool
    let onCancel: () -> Void
    let onSave: (Int, String, String, Bool) -> Void
    let onDelete: () -> Void

    enum ApplyScope {
        case packOnly
        case packAndTemplate
    }

    @State private var quantity: Int
    @State private var selectedCategory: String
    @State private var notes: String
    @State private var applyScope: ApplyScope = .packOnly
    @State private var showingTemplateConfirmation = false

    init(
        itemName: String,
        quantity: Int,
        category: String,
        notes: String,
        showsTemplateOption: Bool,
        onCancel: @escaping () -> Void,
        onSave: @escaping (Int, String, String, Bool) -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.itemName = itemName
        self.showsTemplateOption = showsTemplateOption
        self.onCancel = onCancel
        self.onSave = onSave
        self.onDelete = onDelete
        _quantity = State(initialValue: max(quantity, 1))
        _selectedCategory = State(initialValue: category)
        _notes = State(initialValue: notes)
    }

    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    header
                    itemCard
                    quantityCard
                    categoryCard
                    if showsTemplateOption {
                        applyChangesCard
                    }
                    notesCard
                    deleteButton
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.top, AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xxl)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private var header: some View {
        HStack {
            Button("Cancel") {
                onCancel()
            }
            .font(AppTheme.Typography.callout())
            .foregroundStyle(AppTheme.Colors.textSecondary)

            Spacer()

            Text("Edit Item")
                .font(AppTheme.Typography.headline())
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Spacer()

            Button("Save") {
                onSave(quantity, selectedCategory, notes, applyScope == .packAndTemplate)
            }
            .font(AppTheme.Typography.callout())
            .foregroundStyle(AppTheme.Colors.primary)
        }
    }

    private var itemCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("ITEM NAME")
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.textSecondary)
            Text(itemName)
                .font(.system(size: 32, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.Colors.textPrimary)
        }
        .padding(AppTheme.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                .fill(AppTheme.Colors.surface)
        )
        .applyShadow(AppTheme.Shadows.subtle)
    }

    private var applyChangesCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("APPLY CHANGES TO")
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.textSecondary)

            VStack(spacing: AppTheme.Spacing.sm) {
                applyOptionRow(
                    title: "This pack only",
                    subtitle: "Edits stay only in this pack.",
                    isSelected: applyScope == .packOnly
                ) {
                    applyScope = .packOnly
                }

                applyOptionRow(
                    title: "This pack + update template",
                    subtitle: "Also updates the template item.",
                    isSelected: applyScope == .packAndTemplate
                ) {
                    if applyScope != .packAndTemplate {
                        showingTemplateConfirmation = true
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                .fill(AppTheme.Colors.surface)
        )
        .applyShadow(AppTheme.Shadows.subtle)
        .alert("Update template too?", isPresented: $showingTemplateConfirmation) {
            Button("Update Template", role: .destructive) {
                applyScope = .packAndTemplate
            }
            Button("Cancel", role: .cancel) {
                applyScope = .packOnly
            }
        } message: {
            Text("This will affect future packs created from it.")
        }
    }

    private func applyOptionRow(
        title: String,
        subtitle: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.textSecondary)

                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(title)
                        .font(AppTheme.Typography.callout())
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    Text(subtitle)
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                }

                Spacer()
            }
            .padding(AppTheme.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                    .fill(AppTheme.Colors.surfaceElevated)
            )
        }
        .buttonStyle(.plain)
    }

    private var quantityCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("QUANTITY")
                    .font(AppTheme.Typography.caption())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                Spacer()
                Text("Total: \(quantity)")
                    .font(AppTheme.Typography.callout())
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }

            HStack(spacing: AppTheme.Spacing.lg) {
                quantityButton(icon: "minus", isPrimary: false) {
                    quantity = max(quantity - 1, 1)
                }

                Text("\(quantity)")
                    .font(.system(size: 34, weight: .semibold, design: .rounded))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .frame(maxWidth: .infinity)

                quantityButton(icon: "plus", isPrimary: true) {
                    quantity += 1
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                .fill(AppTheme.Colors.surface)
        )
        .applyShadow(AppTheme.Shadows.subtle)
    }

    private func quantityButton(icon: String, isPrimary: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(isPrimary ? .black : AppTheme.Colors.textPrimary)
                .frame(width: 64, height: 64)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                        .fill(isPrimary ? AppTheme.Colors.primary : AppTheme.Colors.surfaceElevated)
                )
        }
        .buttonStyle(.plain)
    }

    private var categoryCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("CATEGORY")
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.textSecondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(categoryOptions) { option in
                        CategoryChip(
                            title: option.name,
                            icon: option.icon,
                            isSelected: selectedCategory == option.name
                        )
                        .onTapGesture {
                            selectedCategory = option.name
                        }
                    }
                }
                .padding(.bottom, AppTheme.Spacing.sm)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                .fill(AppTheme.Colors.surface)
        )
        .applyShadow(AppTheme.Shadows.subtle)
    }

    private var notesCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("NOTES")
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.textSecondary)

            ZStack(alignment: .topLeading) {
                if notes.isEmpty {
                    Text("Add specific details like 'Wool ones only'\nor 'EU plug adapter'")
                        .font(AppTheme.Typography.body())
                        .foregroundStyle(AppTheme.Colors.textSecondary.opacity(0.6))
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, AppTheme.Spacing.sm)
                }

                TextEditor(text: $notes)
                    .font(AppTheme.Typography.body())
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 120)
                    .padding(AppTheme.Spacing.xs)
            }
            .padding(AppTheme.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                    .fill(AppTheme.Colors.surfaceElevated)
            )
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.xl)
                .fill(AppTheme.Colors.surface)
        )
        .applyShadow(AppTheme.Shadows.subtle)
    }

    private var deleteButton: some View {
        Button(action: onDelete) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "trash")
                Text("Delete Item")
            }
            .font(AppTheme.Typography.callout())
            .foregroundStyle(Color.red)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
        .buttonStyle(.plain)
    }
}

private struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
            Text(title)
                .font(AppTheme.Typography.callout())
        }
        .foregroundStyle(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.textSecondary)
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                .fill(isSelected ? AppTheme.Colors.primary.opacity(0.18) : AppTheme.Colors.surfaceElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                .stroke(isSelected ? AppTheme.Colors.primary : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        PackDetailView(packName: "Europe Summer '24")
    }
}
