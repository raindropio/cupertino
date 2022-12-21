import Foundation
import StoreKit

func getSKReceipt() async throws -> String {
    //refresh
    let _: Bool = try await withCheckedThrowingContinuation { continuation in
        let _ = ReceiptRefresher { error in
            if let error {
                continuation.resume(throwing: error)
            } else {
                continuation.resume(returning: true)
            }
        }
    }
    
    //read from file
    if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
        FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
        let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
        return receiptData.base64EncodedString(options: [])
    }
    
    throw SKError(.unknown)
}

fileprivate class ReceiptRefresher: NSObject, SKRequestDelegate {
    var callback: ((Error?) -> Void)? = nil
    
    init(callback: @escaping (Error?) -> Void) {
        self.callback = callback
        super.init()
        
        let request = SKReceiptRefreshRequest(receiptProperties: nil)
        request.delegate = self
        request.start()
    }
    
    func requestDidFinish(_ request: SKRequest) {
        if request is SKReceiptRefreshRequest {
            callback?(nil)
            callback = nil
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKReceiptRefreshRequest {
            callback?(error)
            callback = nil
        }
    }
}
