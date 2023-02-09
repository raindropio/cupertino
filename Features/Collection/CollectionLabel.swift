import SwiftUI
import API

public func CollectionLabel(_ collection: SystemCollection) -> some View {
    System(collection: collection)
}

public func CollectionLabel(_ collection: UserCollection, withLocation: Bool = false) -> some View {
    User(collection: collection, withLocation: withLocation)
}

public func CollectionLabel(_ id: Int, withLocation: Bool = false) -> some View {
    ById(id: id, withLocation: withLocation)
}

fileprivate struct ById: View {
    @EnvironmentObject private var c: CollectionsStore

    var id: Int
    var withLocation: Bool
    
    var body: some View {
        if let collection = c.state.user[id] {
            User(collection: collection, withLocation: withLocation)
        } else if let collection = c.state.system[id] {
            System(collection: collection)
        }
    }
}

fileprivate struct System: View {
    var collection: SystemCollection
    
    var body: some View {
        Label {
            Text(collection.title)
                .lineLimit(1)
                .fixedSize()
        } icon: {
            CollectionIcon(collection)
        }
            .badge(collection.count)
            .listItemTint(collection.color)
    }
}

fileprivate struct User: View {
    var collection: UserCollection
    var withLocation: Bool
    
    public var body: some View {
        Label {
            HStack(spacing: 0) {
                if withLocation {
                    CollectionLocation(collection: collection)
                        .lineLimit(1)
                        .truncationMode(.head)
                        .foregroundStyle(.secondary)
                }
                
                Text(collection.title+" ")
                    .lineLimit(1)
                    .layoutPriority(1)
                    .fixedSize()
            }
        } icon: {
            CollectionIcon(collection)
        }
            .badge(collection.count)
            .listItemTint(.monochrome)
    }
}
