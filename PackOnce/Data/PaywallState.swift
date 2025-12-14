import Foundation

final class PaywallState: ObservableObject {
    @Published var isPresented: Bool = false
    @Published var debugProUnlocked: Bool = false
}
