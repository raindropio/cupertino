import SwiftUI
import API
import UI

struct CollectionIcon<C: CollectionType>: View {
    @Environment(\.controlSize) private var controlSize
    
    var cover: URL?
    var systemImage: String
    
    var body: some View {
        Group {
            if let cover {
                #if os(macOS)
                Thumbnail(cover, width: 16, height: 16)
                #else
                Thumbnail(cover, width: controlSize == .small ? 16 : 25, height: controlSize == .small ? 16 : 25)
                #endif
            } else {
                Image(systemName: systemImage)
            }
        }
        .fixedSize()
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
