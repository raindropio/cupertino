import SwiftUI
import UniformTypeIdentifiers

public extension View {
    func fileImporter(isPresented: Binding<Bool>, allowedContentTypes: [UTType], allowsMultipleSelection: Bool, onCompletion: @escaping ([NSItemProvider]) -> Void) -> some View {
        fileImporter(isPresented: isPresented, allowedContentTypes: allowedContentTypes, allowsMultipleSelection: allowsMultipleSelection) {
            switch $0 {
            case .success(let urls):
                onCompletion(urls.map { .init(item: $0 as NSURL, typeIdentifier: UTType.fileURL.identifier) })
            case .failure(_):
                onCompletion([])
            }
        }
    }
}
