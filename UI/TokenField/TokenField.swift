import SwiftUI

public struct TokenField<S: RawRepresentable<String> & Identifiable, SV: View> {
    @Environment(\.tokenFieldStyle) private var style
    
    var title: String
    @Binding var value: [String]
    var recent: [String]
    var suggestions: ForEach<[S], S.ID, SV>
    
    public init(
        _ title: String,
        value: Binding<[String]>,
        recent: [String] = [],
        suggestions: () -> ForEach<[S], S.ID, SV>
    ) {
        self.title = title
        self._value = value
        self.recent = recent
        self.suggestions = suggestions()
    }
}

extension TokenField: View {
    public var body: some View {
        switch style {
        case .automatic, .menu:
            NavigationLink {
                TokenPicker(value: $value, recent: recent, suggestions: suggestions)
                    .navigationTitle(title)
            } label: {
                if value.isEmpty {
                    Text(title)
                } else {
                    Text(value, format: .list(type: .and))
                }
            }
            
        case .inline:
            TokenPicker(value: $value, recent: recent, suggestions: suggestions)
        }
    }
}
