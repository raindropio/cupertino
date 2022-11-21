import Foundation

extension RaindropsState {
    mutating func updateSegments(_ raindrop: Raindrop) {
        updateSegments([raindrop])
    }
    
    /// Depending on `collection` value update segments `ids` array's
    mutating func updateSegments(_ raindrops: [Raindrop]) {
        for (find, segment) in segments {
            guard !find.isSearching else { continue }
            
            for item in raindrops {
                let contains = segment.ids.contains(item.id)
                var shouldBeIn = item.collection == find.collectionId
                if find.collectionId == 0 {
                    shouldBeIn = item.collection != -99
                }
                
                //update
                if shouldBeIn {
                    if !contains {
                        segments[find]?.ids.insert(item.id, at: 0)
                    }
                }
                //remove
                else if contains {
                    let ids = segments[find]?.ids.filter { $0 != item.id } ?? []
                    segments[find]?.ids = ids
                }
            }
        }
    }
    
    mutating func reorderSegments(_ raindrop: Raindrop) {
        guard let order = raindrop.order
        else { return }
                
        for (find, segment) in segments {
            guard segment.sort == .sort else { continue }
            
            if find.collectionId == raindrop.collection {
                if let index = segments[find]?.ids.firstIndex(of: raindrop.id) {
                    segments[find]?.ids.move(
                        fromOffsets: [index],
                        toOffset: index < order ? order + 1 : order
                    )
                }
            }
        }
    }
}
