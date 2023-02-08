import SwiftUI
import API

struct HighlightEditRow: View {
    @Binding var highlight: Highlight
    
    var body: some View {
        if !highlight.text.isEmpty {
            VStack(spacing: 4) {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(highlight.color.ui)
                        .frame(width: 3)
                        .frame(maxHeight: .infinity)
                        .padding(.vertical, 10)
                    
                    Text(highlight.text)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
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
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                ForEach(Highlight.Color.bestCases.filter { $0 != highlight.color }, id: \.rawValue) { color in
                    Button {
                        highlight.color = color
                    } label: {
                        Image(systemName: "pencil.tip")
                    }
                    .tint(color.ui)
                }
            }
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    highlight.text = ""
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}
