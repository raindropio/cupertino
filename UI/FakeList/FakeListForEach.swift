import SwiftUI

struct FakeListForEach<Item: Identifiable & Hashable, Content: View> {
    public let data: [Item]
    public let content: (_ item: Item) -> Content
    
    @MainActor public init(_ data: [Item], content: @escaping (_ item: Item) -> Content) {
        self.data = data
        self.content = content
    }
    
    //optionals
    var onMove: ((IndexSet, Int) -> Void)?
    public func onMove(perform action: ((IndexSet, Int) -> Void)?) -> some View {
        var copy = self; copy.onMove = action; return copy
    }
}

extension FakeListForEach: View {
    var body: some View {
        ForEach(data) {
            Element(item: $0, content: content)
        }
    }
}
