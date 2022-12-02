import SwiftUI
import API
import UI

struct CollectionIcon<C: CollectionType>: View {
    var cover: URL?
    var systemImage: String
    
    var body: some View {
        if let cover {
            #if os(macOS)
            Thumbnail(cover, width: 16, height: 16)
            #else
            Thumbnail(cover, width: 24, height: 24)
            #endif
        } else {
            Image(systemName: systemImage)
                .imageScale(.large)
        }
    }
}

extension CollectionIcon where C == UserCollection {
    init(_ collection: C) {
        cover = collection.cover
        systemImage = collection.systemImage
    }
}

extension CollectionIcon where C == SystemCollection {
    init(_ collection: C) {
        systemImage = collection.systemImage
    }
}
