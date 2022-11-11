import SwiftUI

extension ImagePicker {
    struct Cell: View, Equatable {
        var url: URL
        var selected: Bool = false
        var width: Double?
        var height: Double?
        var aspectRatio: Double?
        
        var body: some View {
            Group {
                if let width, let height {
                    Thumbnail(
                        url,
                        width: width,
                        height: height
                    )
                } else if let width {
                    Thumbnail(
                        url,
                        width: width,
                        aspectRatio: aspectRatio
                    )
                } else if let height {
                    Thumbnail(
                        url,
                        height: height,
                        aspectRatio: aspectRatio
                    )
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
