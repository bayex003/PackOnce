import Foundation

final class PurchaseManager: ObservableObject {
    @Published var isProActive: Bool

    init(isProActive: Bool = false) {
        self.isProActive = isProActive
    }
}
