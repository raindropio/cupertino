import SwiftUI

public struct ImagePicker {
    @Namespace private var local
    
    var data: [URL]
    @Binding var selection: URL?
    var width: Double?
    var height: Double?
    var aspectRatio: Double?
    var namespace: Namespace.ID?
    
    public init(
        _ data: [URL],
        selection: Binding<URL?>,
        namespace: Namespace.ID? = nil,
        width: Double,
        height: Double
    ) {
        self.data = data
        self._selection = selection
        self.width = width
        self.height = height
        self.namespace = namespace
    }
    
    public init(
        _ data: [URL],
        selection: Binding<URL?>,
        namespace: Namespace.ID? = nil,
        width: Double,
        aspectRatio: Double? = nil
    ) {
        self.data = data
        self._selection = selection
        self.width = width
        self.aspectRatio = aspectRatio
        self.namespace = namespace
    }
    
    public init(
        _ data: [URL],
        selection: Binding<URL?>,
        namespace: Namespace.ID? = nil,
        height: Double,
        aspectRatio: Double? = nil
    ) {
        self.data = data
        self._selection = selection
        self.height = height
        self.aspectRatio = aspectRatio
        self.namespace = namespace
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
                        .matchedGeometryEffect(id: url, in: namespace ?? local)
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
