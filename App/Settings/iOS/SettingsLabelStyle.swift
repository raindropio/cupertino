import SwiftUI

#if os(iOS)
struct SettingsLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            ZStack {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(.tint)
                    .frame(width: 28, height: 28)
                
                configuration.icon
                    .foregroundColor(.white)
                    .symbolRenderingMode(.monochrome)
                    .symbolVariant(.fill)
            }
        }
    }
}
#endif
