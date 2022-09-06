import SwiftUI

public extension View {
    func tabItem(systemImage: String) -> some View {
        tabItem {
            TabItemCenterImage(systemImage: systemImage)
        }
    }
}

fileprivate struct TabItemCenterImage: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    var systemImage: String
    
    var body: some View {
        if let uiImage = UIImage(systemName: systemImage) {
            if verticalSizeClass == .regular {
                Image(uiImage: uiImage.withBaselineOffset(fromBottom: 14))
            } else {
                Image(uiImage: uiImage)
            }
        }
    }
}
