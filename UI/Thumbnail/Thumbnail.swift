import SwiftUI
import Nuke
import NukeUI

public struct Thumbnail {
    var url: URL?
    var width: CGFloat?
    var height: CGFloat?
    var aspectRatio: CGFloat?
    
    static var cacheAspect = [URL:CGFloat]()
    static let diskCache: ImagePipeline = {
        var configuration = ImagePipeline.Configuration.withDataCache
        configuration.dataCachePolicy = .storeAll
        return ImagePipeline(configuration: configuration)
    }()
        
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
    var resize: ImageProcessors.Resize {
        if let width, let height {
            return .init(
                size: .init(width: width, height: height),
                contentMode: .aspectFill,
                crop: true
            )
        } else if let width {
            return .init(width: width)
        } else if let height {
            return .init(height: height)
        } else {
            let w = Int(width ?? (height ?? 0) / (aspectRatio ?? 1))
            let h = Int(height ?? (width ?? 0) / (aspectRatio ?? 1))
            return .init(
                size: .init(width: w, height: h),
                contentMode: .aspectFill,
                crop: true
            )
        }
    }
    
    @MainActor
    var base: LazyImage<NukeUI.Image> {
        LazyImage(url: url)
            .animation(nil)
            .processors([resize])
            .pipeline(Self.diskCache)
            .priority(.veryLow)
    }
    
    public var body: some View {
        //fixed size
        if let width, let height {
            base
                .frame(width: width, height: height)
                .fixedSize()
        }
        //aspect ratio
        else if let aspectRatio {
            base
                .aspectRatio(aspectRatio, contentMode: .fit)
        }
        //downsampled
        else {
            base
                .onSuccess {
                    //cache aspect ratio for later
                    if let url, aspectRatio == nil, (width == nil || height == nil) {
                        Self.cacheAspect[url] = $0.image.size.width / $0.image.size.height
                    }
                }
                .aspectRatio(url != nil ? Self.cacheAspect[url!] : nil, contentMode: .fit)
        }
    }
}


struct Thumbnail_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Thumbnail(
                URL(string: "https://via.placeholder.com/200x100"),
                width: 100,
                height: 100
            )
            
            Thumbnail(
                URL(string: "https://via.placeholder.com/200x100"),
                width: 200
            )
        }
    }
}
