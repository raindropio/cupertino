import Foundation

extension URL {
    public var isValidFileURL: Bool {
        ((try? resourceValues(forKeys:[.fileSizeKey]))?.fileSize ?? 0) > 0
    }
}
