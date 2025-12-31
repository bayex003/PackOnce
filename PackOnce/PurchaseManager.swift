import Foundation
internal import Combine

final class PurchaseManager: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    @Published var isProActive: Bool

    init(isProActive: Bool = false) {
        self.isProActive = isProActive
    }
}
