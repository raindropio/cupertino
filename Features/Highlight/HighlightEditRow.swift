import SwiftUI
import API

struct HighlightEditRow: View {
    @State private var selectColor = false
    @Binding var highlight: Highlight
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(highlight.color.ui)
                    .frame(width: 3)
                    .frame(maxHeight: .infinity)
                    .padding(.vertical, 10)
                
                Text(highlight.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
                ._onButtonGesture(pressing: nil) {
                    selectColor.toggle()
                }
                .confirmationDialog("Highlight color", isPresented: $selectColor, titleVisibility: .visible) {
                    ForEach(Highlight.Color.bestCases, id: \.rawValue) { color in
                        Button(color.rawValue.capitalized, role: color == .red ? .destructive : nil) {
                            highlight.color = color
                        }
                    }
                }
            
            TextField("Note", text: $highlight.note, axis: .vertical)
                .preventLineBreaks(text: $highlight.note)
            
            Text(highlight.created, formatter: .shortDateTime)
                .lineLimit(1)
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 4)
        }
            .padding(.vertical, 8)
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
}
