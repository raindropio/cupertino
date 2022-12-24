import Foundation

extension CollectionsState {
    /// Make sure to call this method after any changes to groups and/or user
    mutating func clean() {
        //keep only existings ROOT collections
        groups = groups.map {
            var group = $0
            group.collections = group.collections.filter { id in
                user[id] != nil && user[id]?.parent == nil
            }
            return group
        }
        
        //create blank group
        if groups.isEmpty {
            groups = [.blank]
        }

        //small fixes
        var fixedParents = Set<UserCollection.ID>()
        
        for (id, collection) in user {
            if let parent = collection.parent {
                if !fixedParents.contains(parent) {
                    //set correct `sort` value for siblings
                    let siblings = childrens(of: parent)
                    for (i, sibling) in siblings.enumerated() {
                        user[sibling.id]?.sort = i
                    }
                    fixedParents.insert(parent)
                }
            }
            else {
                let i = groups.first { $0.collections.contains(id) }?
                    .collections.firstIndex(of: id)
                
                //set correct `sort` for root collection
                if let i {
                    user[id]?.sort = i
                }
                //collection is out of groups, append it to first group
                else {
                    groups[groups.indices.first!].collections.append(id)
                }
            }
        }
    }
}

extension CollectionsState {
    /// Make sure to call this method after collection sort or parent change
    mutating func reordered(_ id: UserCollection.ID) {
        guard let collection = user[id] else { return }
        
        //fix siblings sort if required
        if let parent = collection.parent {
            let siblings = childrens(of: parent)
            if siblings.count > 1, collection.sort != siblings.firstIndex(of: collection) {
                let relatives = siblings.filter { $0.id != collection.id }.enumerated()
                for (i, relative) in relatives {
                    user[relative.id]?.sort = i >= (collection.sort ?? 0) ? i + 1 : i
                }
            }
        }
        
        //fix root collections sort if required
        if collection.parent == nil {
            let g = groups.firstIndex { $0.collections.contains(id) } ?? 0
            let s = groups[g].collections.firstIndex(of: id) ?? 0
            
            if s != collection.sort {
                //remove from groups (just to prevent duplicates)
                groups = groups.map {
                    var group = $0
                    group.collections = group.collections.filter { $0 != collection.id }
                    return group
                }
                
                //insert to specific position inside group
                if let sort = collection.sort {
                    groups[g].collections
                        .insert(
                            collection.id,
                            at: max(0, min(sort, groups[g].collections.count))
                        )
                }
                //append to end if no prefered sort
                else {
                    groups[g].collections
                        .append(collection.id)
                }
            }
        }
    }
}
