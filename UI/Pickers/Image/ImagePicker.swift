import SwiftUI

public struct ImagePicker {
    var data: [URL]
    @Binding var selection: URL?
    var width: Double?
    var height: Double?
    var aspectRatio: Double?
    
    public init(
        _ data: [URL],
        selection: Binding<URL?>,
        width: Double,
        height: Double
    ) {
        self.data = data
        self._selection = selection
        self.width = width
        self.height = height
    }
    
    public init(
        _ data: [URL],
        selection: Binding<URL?>,
        width: Double,
        aspectRatio: Double? = nil
    ) {
        self.data = data
        self._selection = selection
        self.width = width
        self.aspectRatio = aspectRatio
    }
    
    public init(
        _ data: [URL],
        selection: Binding<URL?>,
        height: Double,
        aspectRatio: Double? = nil
    ) {
        self.data = data
        self._selection = selection
        self.height = height
        self.aspectRatio = aspectRatio
    }
}

extension ImagePicker: View {
    public var body: some View {
        ScrollView(.vertical) {
            Columns(width: width) {
                ForEach(data, id: \.self) { url in
                    Cell(
                        url: url,
                        selected: url == selection,
                        width: width,
                        height: height,
                        aspectRatio: aspectRatio
                    )
                        .equatable()
                        .onTapGesture {
                            selection = url
                        }
                }
            }
        }
            .ignoresSafeArea(.keyboard)
    }
}

extension ImagePicker: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.data == rhs.data &&
        lhs.selection == rhs.selection &&
        lhs.width == rhs.width &&
        lhs.height == rhs.height &&
        lhs.aspectRatio == rhs.aspectRatio
    }
}
