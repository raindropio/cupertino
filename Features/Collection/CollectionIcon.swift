import SwiftUI
import API
import UI

public func CollectionIcon(_ collection: UserCollection, fallbackImageName: String? = nil) -> some View {
    CI(cover: collection.cover, systemImage: fallbackImageName ?? collection.systemImage)
}

public func CollectionIcon(_ collection: SystemCollection) -> some View {
    CI(systemImage: collection.systemImage)
}

fileprivate struct CI: View {
    @Environment(\.controlSize) private var controlSize
    
    var cover: URL?
    var systemImage: String
    
    var body: some View {
        Group {
            if let cover {
                #if os(macOS)
                Thumbnail(cover, width: 16, height: 16)
                #else
                //use resize on server to prevent large data load
                Thumbnail(Rest.renderImage(cover, options: .width(25), .height(25)))
                    .frame(
                        width: controlSize == .small ? 16 : 25,
                        height: controlSize == .small ? 16 : 25
                    )
                #endif
            } else {
                Image(systemName: systemImage)
            }
        }
            .fixedSize()
    }
}
