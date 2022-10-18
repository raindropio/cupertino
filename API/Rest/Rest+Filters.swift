import Foundation

//MARK: - Get
extension Rest {
    public func filtersGet(_ find: FindBy) async throws -> [Filter] {
        let res: FiltersGetResponse = try await fetch.get(
            "filters/\(find.collectionId)",
            query: find.query
                + [.init(name: "nested", value: "true")]
        )

        var filters: [Filter] = []
        
        //important
        if let important = res.important {
            filters.append(.init(.important, count: important.count))
        }
        
        //highlights
        if let highlights = res.highlights {
            filters.append(.init(.highlights, count: highlights.count))
        }
        
        //tags
        if let tags = res.tags {
            filters += tags.compactMap {
                if let _id = $0._id {
                    return Filter(.tag(_id), count: $0.count)
                }
                return nil
            }
        }
        
        //types
        if let types = res.types {
            filters += types.compactMap {
                if let _id = $0._id {
                    return Filter(.type(.init(stringLiteral: _id)), count: $0.count)
                }
                return nil
            }
        }
        
        //file
        if let file = res.file {
            filters.append(.init(.file, count: file.count))
        }
        
        //created
        if let created = res.created {
            filters += created.compactMap {
                if let _id = $0._id {
                    return Filter(.created(_id), count: $0.count)
                }
                return nil
            }
        }
        
        //notag
        if let notag = res.notag {
            filters.append(.init(.notag, count: notag.count))
        }
                
        //broken
        if let broken = res.broken {
            filters.append(.init(.broken, count: broken.count))
        }
        
        //duplicate
        if let duplicate = res.duplicate {
            filters.append(.init(.duplicate, count: duplicate.count))
        }
                        
        return filters
    }
    
    fileprivate struct FiltersGetResponse: Codable {        
        var tags: [Element]?
        var types: [Element]?
        var created: [Element]?
        var notag: Element?
        var important: Element?
        var broken: Element?
        var file: Element?
        var duplicate: Element?
        var highlights: Element?
        
        struct Element: Codable {
            var _id: String?
            var count: Int = 0
        }
    }
}
