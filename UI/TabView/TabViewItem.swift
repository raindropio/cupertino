import SwiftUI

public struct TabViewItem {
    var titleKey: LocalizedStringKey
    var systemImage: String = ""
    
    public init(_ titleKey: LocalizedStringKey = "", systemImage: String) {
        self.titleKey = titleKey
        self.systemImage = systemImage
    }
}

extension TabViewItem: View {
    public var body: some View {
        if titleKey == "",
           let uiImage = UIImage(systemName: systemImage) {
            Image(uiImage: uiImage.withBaselineOffset(fromBottom: 12))
                .symbolVariant(.fill)
        } else {
            Label(titleKey, systemImage: systemImage)
        }
    }
}
