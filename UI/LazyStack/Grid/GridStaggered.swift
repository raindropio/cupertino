import SwiftUI

struct GridStaggered<D: RandomAccessCollection & Hashable, Content: View> {
    @Environment(\.gridScrollColumns) private var columns
    @ScaledMetric private var gap = LazyStackLayout.gap(.grid(0, true))
    
    let data: D
    let width: Double
    let content: (D) -> Content
    
    init(_ data: D, _ width: Double, content: @escaping (D) -> Content) {
        self.data = data
        self.width = width
        self.content = content
    }
}

extension GridStaggered: View {
    private var cells: [D] {
        let verticals = Array(0...(max(columns, 1)-1))
        let indexes = Array(0...(max(data.count, 1)-1))
                
        return verticals.compactMap { column in
            indexes
                .filter { $0 % columns == column }
                .compactMap {
                    let index = $0 as! D.Index
                    return data.indices.contains(index) ? data[index] : nil
                }
                as? D
        }
    }
    
    var body: some View {
        Memorized(cells: cells, spacing: gap / 2, content: content)
            .equatable()
    }
}

extension GridStaggered {
    fileprivate struct Memorized: View, Equatable {
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.cells == rhs.cells
        }
        
        let cells: [D]
        let spacing: Double
        let content: (D) -> Content
        
        var body: some View {
            HStack(alignment: .top, spacing: spacing) {
                ForEach(cells, id: \.self) { column in
                    LazyVStack(alignment: .leading, spacing: spacing) {
                        content(column)
                    }
                }
            }
                .scenePadding(.horizontal)
                .scenePadding(.bottom)
        }
    }
}
