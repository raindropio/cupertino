import SwiftUI

struct ChildrenLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
                .foregroundColor(.accentColor)
                .symbolVariant(.fill)
                .imageScale(.large)
                .frame(width: 32, height: 32)
            
            configuration.title
        }
        .contentShape(Rectangle())
    }
}
