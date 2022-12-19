import SwiftUI
import AuthenticationServices

public class WebAuth: NSObject, ObservableObject {
    private var session: ASWebAuthenticationSession?
    
    @MainActor
    public func callAsFunction(_ url: URL, scheme: String) async throws -> URL? {
        try await withCheckedThrowingContinuation { continuation in
            session?.cancel()
            
            session = .init(url: url, callbackURLScheme: scheme) { [weak self] callbackUrl, error in
                defer {
                    self?.session = nil
                }
                
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: callbackUrl)
                }
            }
            
            session?.presentationContextProvider = self
            session?.start()
        }
    }
}

extension WebAuth: ASWebAuthenticationPresentationContextProviding {
    @MainActor
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
