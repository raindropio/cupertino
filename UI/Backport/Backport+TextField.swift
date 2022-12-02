import SwiftUI

@available(iOS, deprecated: 16.0)
public extension Backport where Wrapped == Any {
    struct TextField {
        var titleKey: LocalizedStringKey
        @Binding var text: String
        var prompt: Text?
        var axis: Axis
        
        public init(
            _ titleKey: LocalizedStringKey,
            text: Binding<String>,
            prompt: Text? = nil,
            axis: Axis
        ) {
            self.titleKey = titleKey
            self._text = text
            self.prompt = prompt
            self.axis = axis
        }
    }
}

extension Backport.TextField: View {
    public var body: some View {
        if #available(iOS 16, *) {
            SwiftUI.TextField(titleKey, text: $text, prompt: prompt, axis: axis)
        } else {
            AutoGrowTextEditor(text: $text, prompt: titleKey)
        }
    }
}

fileprivate struct AutoGrowTextEditor: View {
    @Binding var text: String
    var prompt: LocalizedStringKey = ""

    @ScaledMetric private var horizontalOffset = 5.5
    #if os(iOS)
    @ScaledMetric private var verticalOffset = 8.5
    @ScaledMetric private var paddingVertical = -3
    @ScaledMetric private var rowInsetHorizontal = 20
    #else
    @ScaledMetric private var paddingVertical = 0
    #endif
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, -horizontalOffset)
                .layoutPriority(-1)
            
            if text.isEmpty {
                Text(prompt)
                    .foregroundColor(.tertiaryLabel)
                    .allowsHitTesting(false)
                    #if os(iOS)
                    .padding(.vertical, verticalOffset)
                    #endif
            }
            
            Text(text)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .layoutPriority(1)
                .allowsHitTesting(false)
                #if os(iOS)
                .padding(.vertical, verticalOffset)
                #endif
                .opacity(0)
        }
            #if os(iOS)
            .listRowInsets(.init(top: 0, leading: rowInsetHorizontal, bottom: 0, trailing: rowInsetHorizontal))
            #endif
    }
}
