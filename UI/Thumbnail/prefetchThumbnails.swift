import SwiftUI
import Nuke

public extension View {
    func prefetchThumbnails<I: Collection>(items: I, transform: @escaping (I.Element) -> URL?) -> some View {
        modifier(PT(items: items, transform: transform))
    }
}

fileprivate struct PT<I: Collection>: ViewModifier {
    @State private var prefetched = Set<URL>()
    @State private var prefetcher = ImagePrefetcher(
        pipeline: Thumbnail.pipeline,
        destination: .diskCache,
        maxConcurrentRequestCount: 100
    )
    
    var items: I
    var transform: (I.Element) -> URL?
    
    @Sendable func onChange() async {
        let prefetch = items
            .compactMap {
                if let url = transform($0), !prefetched.contains(url) {
                    return url
                }
                return nil
            }
        
        prefetcher.startPrefetching(with: prefetch)
                
        prefetched.formUnion(prefetch)
    }
    
    func body(content: Content) -> some View {
        content.task(id: items.count, priority: .background, debounce: 0.3, onChange)
    }
}
