import SwiftUI

struct GridStaggered<D: RandomAccessCollection, Content: View> {
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
    func group(_ columns: Int, _ column: Int) -> D {
        let rows: [Int] = Array(0..<Int(ceil(Double(data.count) / Double(columns))))
        
        return rows.compactMap {
            let index = $0 * columns + column
            
            if index < data.count {
                return data[index as! D.Index]
            } else {
                return nil
            }
        } as! D
    }
    
    var body: some View {
        let columns = min(columns, data.count)
        
        HStack(alignment: .top, spacing: gap / 2) {
            ForEach(0..<columns, id: \.self) { column in
                LazyVStack(alignment: .leading, spacing: gap / 2) {
                    content(group(columns, column))
                }
            }
        }
            .scenePadding(.horizontal)
            .padding(.vertical, gap / 3)
    }
}
