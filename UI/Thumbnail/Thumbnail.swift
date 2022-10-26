import SwiftUI
import Kingfisher

public struct Thumbnail {
    @Environment(\.displayScale) private var displayScale
    
    var url: URL?
    var width: CGFloat?
    var height: CGFloat?
    var aspectRatio: CGFloat?
    
    static var cacheAspect = [URL:CGFloat]()
        
    public init(
        _ url: URL? = nil,
        width: CGFloat,
        height: CGFloat
    ) {
        self.url = url
        self.width = width
        self.height = height
    }
    
    public init(
        _ url: URL? = nil,
        width: CGFloat,
        aspectRatio: CGFloat? = nil
    ) {
        self.url = url
        self.width = width
        self.aspectRatio = aspectRatio
    }
    
    public init(
        _ url: URL? = nil,
        height: CGFloat,
        aspectRatio: CGFloat? = nil
    ) {
        self.url = url
        self.height = height
        self.aspectRatio = aspectRatio
    }
}

extension Thumbnail: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.url == rhs.url &&
        lhs.width == rhs.width &&
        lhs.height == rhs.height &&
        lhs.aspectRatio == rhs.aspectRatio
    }
}

extension Thumbnail: View {
    var isSmall: Bool {
        if let width, width <= 50 {
            return true
        } else if let height, height <= 50 {
            return true
        }
        return false
    }
    
    var naturalSize: CGSize {
        let w = Int(width ?? (height ?? 0) / (aspectRatio ?? 1))
        let h = Int(height ?? (width ?? 0) / (aspectRatio ?? 1))

        return CGSize(
            width: w * Int(displayScale),
            height: h * Int(displayScale)
        )
    }
    
    var base: some KFImageProtocol {
        KFImage(url)
            .backgroundDecode(!isSmall)
            .loadDiskFileSynchronously(isSmall)
            .cancelOnDisappear(true)
            .cacheOriginalImage()
            .interpolation(.low)
            .antialiased(false)
            .resizable()
            .placeholder {
                Rectangle().foregroundStyle(.quaternary)
            }
            .onSuccess {
                //cache aspect ratio for later
                if let url, aspectRatio == nil, (width == nil || height == nil) {
                    Self.cacheAspect[url] = $0.image.size.width / $0.image.size.height
                }
            }
    }
    
    public var body: some View {
        //fixed size
        if let width, let height {
            base
                .resizing(referenceSize: naturalSize, mode: .aspectFill)
                .cropping(size: naturalSize)
                .frame(width: width, height: height)
                .fixedSize()
        }
        //aspect ratio
        else if let aspectRatio {
            base
                .resizing(referenceSize: naturalSize, mode: .aspectFill)
                .cropping(size: naturalSize)
                .aspectRatio(aspectRatio, contentMode: .fit)
        }
        //downsampled
        else {
            base
                .downsampling(size: naturalSize)
                .aspectRatio(url != nil ? Self.cacheAspect[url!] : nil, contentMode: .fit)
        }
    }
}
