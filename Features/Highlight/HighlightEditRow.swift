import SwiftUI
import API

struct HighlightEditRow: View {
    @Binding var highlight: Highlight
    
    var body: some View {
        if !highlight.text.isEmpty {
            Section {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(highlight.color.ui)
                        .frame(width: 3)
                        .frame(maxHeight: .infinity)
                        .padding(.vertical, 10)
                    
                    Text(highlight.text)
                        .foregroundColor(.primary)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                    .padding(.top, 6)
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
                    .listRowSeparator(.hidden)
                
                TextField("Note", text: $highlight.note, axis: .vertical)
                    .preventLineBreaks(text: $highlight.note)
                    .proEnabled()
                    .textSelection(.enabled)
            } footer: {
                Text(highlight.created, formatter: .shortDateTime)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .trailing)

            }
        }
    }
}
