import Foundation
import StoreKit

@MainActor
final class StoreKitService: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedIDs: Set<String> = []
    @Published var isLoading = false
    @Published var purchaseError: String?

    var proProduct: Product? {
        products.first
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let ids = ["com.example.packonce.pro"]
            products = try await Product.products(for: ids)
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    purchasedIDs.insert(transaction.productID)
                }
            }
        } catch {
            purchaseError = "Unable to load pricing right now."
        }
    }

    func purchase() async -> Bool {
        guard let product = products.first else {
            purchaseError = "Unable to load product."
            return false
        }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    purchasedIDs.insert(transaction.productID)
                    await transaction.finish()
                    return true
                }
            default:
                break
            }
        } catch {
            purchaseError = error.localizedDescription
        }
        return false
    }

    func restore() async {
        do {
            for await result in Transaction.all {
                if case .verified(let transaction) = result {
                    purchasedIDs.insert(transaction.productID)
                    await transaction.finish()
                }
            }
        } catch {
            purchaseError = error.localizedDescription
        }
    }

    func isProUnlocked(debugOverride: Bool) -> Bool {
        debugOverride || purchasedIDs.contains("com.example.packonce.pro")
    }
}
