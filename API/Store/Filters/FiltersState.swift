import Foundation

public struct FiltersState: Equatable {
    typealias Groups = [ FindBy : Group ]
    @Cached("fs-groups") var groups = Groups()
    
    var completion = [FindBy: [Filter]]()

    public func general(_ find: FindBy) -> [Filter] {
        self[find].general
    }
    
    public func tags(_ find: FindBy) -> [Filter] {
        self[find].tags
    }
    
    public func created(_ find: FindBy) -> [Filter] {
        self[find].created
    }
    
    public func completion(_ find: FindBy) -> [Filter] {
        if find.text.isEmpty {
            return []
        }
        return completion[find.excludingText()] ?? []
    }
    
    public func raindrops(_ find: FindBy) -> Int {
        self[find].raindrops
    }
    
    public func count(_ find: FindBy) -> Int {
        general(find).count +
        tags(find).count +
        created(find).count +
        completion(find).count
    }
    
    public func isEmpty(_ find: FindBy) -> Bool {
        count(find) == 0
    }
}
