import SwiftUI

extension ImagePicker {
    struct Cell: View, Equatable {
        var url: URL
        var selected: Bool = false
        var width: CGFloat?
        var height: CGFloat?
        var aspectRatio: CGFloat?
        
        var body: some View {
            Group {
                if let width, let height {
                    Thumbnail(
                        url,
                        width: width,
                        height: height
                    ).equatable()

                } else if let width {
                    Thumbnail(
                        url,
                        width: width,
                        aspectRatio: aspectRatio
                    ).equatable()
                } else if let height {
                    Thumbnail(
                        url,
                        height: height,
                        aspectRatio: aspectRatio
                    ).equatable()
                }
            }
                .background {
                    if selected {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .foregroundStyle(.selection)
                            .scaleEffect(1.2)
                    }
                }
        }
    }
}
