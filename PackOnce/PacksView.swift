import SwiftUI
import SwiftData

struct PacksView: View {
    @ObservedObject var purchaseManager: PurchaseManager
    @Binding var exportPreference: ExportPreference
    @State private var selectedFilter = "In Progress"
    @State private var selectedPack: Pack?

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Pack.createdAt, order: .reverse) private var packs: [Pack]
    @Query(sort: \Template.title) private var templates: [Template]

    private let filters = ["In Progress", "Pinned", "Recent"]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                        header

                        searchBar

                        filterChips

                        quickStartSection

                        packListSection
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.top, AppTheme.Spacing.lg)
                    .padding(.bottom, 120)
                }

                newPackButton
            }
            .navigationBarHidden(true)
            .navigationDestination(item: $selectedPack) { pack in
                PackDetailView(
                    pack: pack,
                    purchaseManager: purchaseManager,
                    exportPreference: $exportPreference
                )
            }
        }
    }

    private var header: some View {
        HStack {
            Text("Packs")
                .font(.system(size: 32, weight: .semibold, design: .rounded))
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Spacer()

            Button(action: {}) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppTheme.Colors.textPrimary.opacity(0.7))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle().fill(AppTheme.Colors.surfaceElevated)
                    )
            }
            .buttonStyle(.plain)
        }
    }

    private var searchBar: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTheme.Colors.textSecondary)
            Text("Find a pack...")
                .font(AppTheme.Typography.body())
                .foregroundStyle(AppTheme.Colors.textSecondary.opacity(0.85))
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.lg)
                .fill(AppTheme.Colors.surfaceElevated)
        )
    }

    private var filterChips: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ForEach(filters, id: \.self) { filter in
                Button {
                    selectedFilter = filter
                } label: {
                    FilterChip(title: filter, isSelected: selectedFilter == filter)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var quickStartSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("QUICK START")
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .tracking(1)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(templates) { template in
                        Button {
                            selectedPack = createPack(from: template)
                        } label: {
                            QuickStartCard(template: template)
                        }
                        .buttonStyle(.plain)
                    }

                    QuickStartAddButton()
                }
                .padding(.horizontal, 2)
            }
        }
    }

    private var packListSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            ForEach(filteredPacks) { pack in
                NavigationLink {
                    PackDetailView(
                        pack: pack,
                        purchaseManager: purchaseManager,
                        exportPreference: $exportPreference
                    )
                } label: {
                    PackCard(entry: pack)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var newPackButton: some View {
        Button(action: {}) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                Text("New Pack")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(.black)
            .padding(.horizontal, AppTheme.Spacing.xxl)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(
                Capsule().fill(AppTheme.Colors.primary)
            )
            .applyShadow(AppTheme.Shadows.glow)
        }
        .buttonStyle(.plain)
        .padding(.bottom, AppTheme.Spacing.xl)
    }

    private var filteredPacks: [Pack] {
        switch selectedFilter {
        case "Pinned":
            return packs.filter { $0.isPinned }
        case "Recent":
            return packs.sorted { $0.createdAt > $1.createdAt }
        default:
            return packs.filter { $0.packedQuantity < $0.totalQuantity }
        }
    }

    private func createPack(from template: Template) -> Pack {
        let tag = fetchTag(named: "TRAVEL")
        let pack = Pack(
            name: template.title,
            tag: tag,
            subtitle: "New pack",
            subtitleIcon: "calendar",
            subtitleAccent: "muted",
            showProgressRing: false,
            isPinned: false,
            showsProgressBar: true,
            showsStatusLabel: false,
            template: template
        )

        let items = template.items.map { templateItem in
            PackItem(
                name: templateItem.name,
                quantity: templateItem.quantity,
                category: templateItem.category,
                note: templateItem.note,
                isPacked: false,
                isPinned: templateItem.isPinned,
                isLastMinute: templateItem.isLastMinute,
                templateItem: templateItem,
                pack: pack
            )
        }

        pack.items.append(contentsOf: items)
        modelContext.insert(pack)
        return pack
    }

    private func fetchTag(named name: String) -> Tag? {
        let descriptor = FetchDescriptor<Tag>(predicate: #Predicate { $0.name == name })
        return (try? modelContext.fetch(descriptor))?.first
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(AppTheme.Typography.callout())
            .foregroundStyle(isSelected ? .black : AppTheme.Colors.textSecondary)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(
                Capsule().fill(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.surfaceElevated)
            )
    }
}

private struct QuickStartCard: View {
    let template: Template

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            ZStack {
                Circle()
                    .fill(quickStartColor.opacity(0.25))
                    .frame(width: 36, height: 36)
                Image(systemName: template.icon)
                    .foregroundStyle(quickStartColor)
            }

            Text(template.title)
                .font(AppTheme.Typography.callout())
                .foregroundStyle(AppTheme.Colors.textPrimary)

            Text("+")
                .font(AppTheme.Typography.callout())
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                .fill(AppTheme.Colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                        .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                )
        )
    }

    private var quickStartColor: Color {
        switch template.accent {
        case "orange":
            return AppTheme.Colors.warning
        case "blue":
            return AppTheme.Colors.accent
        case "purple":
            return Color(red: 0.7, green: 0.55, blue: 1.0)
        case "teal":
            return AppTheme.Colors.primary
        default:
            return AppTheme.Colors.primary
        }
    }
}

private struct QuickStartAddButton: View {
    var body: some View {
        Button(action: {}) {
            Image(systemName: "plus")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.textSecondary)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                        .fill(AppTheme.Colors.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radii.md)
                                .stroke(AppTheme.Colors.surfaceBorder, lineWidth: 1)
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

private struct PackCard: View {
    let entry: Pack

    var body: some View {
        CardContainer {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        HStack(spacing: AppTheme.Spacing.sm) {
                            Text(entry.name)
                                .font(AppTheme.Typography.headline())
                                .foregroundStyle(AppTheme.Colors.textPrimary)
                            TagBadgeView(title: entry.tagName)
                        }

                        HStack(spacing: AppTheme.Spacing.xs) {
                            Image(systemName: entry.subtitleIcon)
                            Text(entry.subtitle)
                        }
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(subtitleColor)
                    }

                    Spacer()

                    if entry.showProgressRing {
                        ProgressRingWithLabel(progress: entry.progress)
                    } else if entry.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(AppTheme.Colors.primaryMuted)
                    } else {
                        Text("\(entry.packedQuantity)/\(entry.totalQuantity)")
                            .font(AppTheme.Typography.callout())
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                }

                if entry.showProgressRing {
                    Text("\(entry.packedQuantity)/\(entry.totalQuantity) Packed")
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                if entry.showsProgressBar {
                    ProgressBar(
                        progress: entry.progress,
                        fillColor: entry.progress > 0 ? AppTheme.Colors.primary : AppTheme.Colors.primaryMuted
                    )
                } else if entry.showsStatusLabel {
                    Text("Not started")
                        .font(AppTheme.Typography.caption())
                        .foregroundStyle(AppTheme.Colors.textSecondary.opacity(0.6))
                }

                if let adds = entry.lastMinuteAdds {
                    LastMinuteAddsView(count: adds)
                }
            }
        }
    }

    private var subtitleColor: Color {
        switch entry.subtitleAccent {
        case "warning":
            return AppTheme.Colors.warning
        default:
            return AppTheme.Colors.textSecondary
        }
    }
}

private struct TagBadgeView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppTheme.Typography.caption())
            .foregroundStyle(textColor)
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, 3)
            .background(
                Capsule().fill(backgroundColor)
            )
    }

    private var backgroundColor: Color {
        switch title {
        case "TRAVEL":
            return Color(red: 0.2, green: 0.35, blue: 0.6).opacity(0.35)
        case "FITNESS":
            return Color(red: 0.4, green: 0.25, blue: 0.15).opacity(0.6)
        case "FAMILY":
            return Color(red: 0.4, green: 0.25, blue: 0.55).opacity(0.6)
        case "OUTDOOR":
            return Color(red: 0.2, green: 0.4, blue: 0.3).opacity(0.6)
        default:
            return AppTheme.Colors.primary.opacity(0.2)
        }
    }

    private var textColor: Color {
        switch title {
        case "TRAVEL":
            return AppTheme.Colors.accent
        case "FITNESS":
            return AppTheme.Colors.warning
        case "FAMILY":
            return Color(red: 0.8, green: 0.65, blue: 1.0)
        case "OUTDOOR":
            return Color(red: 0.5, green: 0.85, blue: 0.65)
        default:
            return AppTheme.Colors.primary
        }
    }
}

private struct ProgressRingWithLabel: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.Colors.surfaceElevated, lineWidth: 6)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppTheme.Colors.primary, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))

            Text("\(Int(progress * 100))%")
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.textPrimary)
        }
        .frame(width: 48, height: 48)
    }
}

private struct ProgressBar: View {
    let progress: Double
    let fillColor: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppTheme.Colors.surfaceElevated)
                Capsule()
                    .fill(fillColor)
                    .frame(width: max(proxy.size.width * CGFloat(progress), 8))
            }
        }
        .frame(height: 8)
    }
}

private struct LastMinuteAddsView: View {
    let count: Int

    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Text("\(count)")
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.textPrimary)
                .frame(width: 22, height: 22)
                .background(
                    Circle().fill(Color(red: 0.6, green: 0.2, blue: 0.2))
                )

            Text("Last-minute adds")
                .font(AppTheme.Typography.caption())
                .foregroundStyle(AppTheme.Colors.textSecondary)
        }
    }
}

#Preview {
    PacksView(
        purchaseManager: PurchaseManager(),
        exportPreference: .constant(.pdf)
    )
    .modelContainer(for: [Pack.self, Template.self, TemplateItem.self, PackItem.self, Tag.self], inMemory: true)
}
