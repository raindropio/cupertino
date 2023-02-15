import Foundation
import CoreTransferable

extension NSItemProvider {
    /// async version of `loadTransferable`
    public func loadTransferable<T: Transferable>(type transferableType: T.Type) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            _ = self.loadTransferable(type: transferableType) {
                switch $0 {
                case .success(let result):
                    continuation.resume(returning: result)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
