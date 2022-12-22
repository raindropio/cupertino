import SwiftUI
import Nuke
import NukeUI

public struct Thumbnail {
    #if os(macOS)
    @Environment(\.displayScale) private var displayScale
    #else
    private var displayScale = 1.0
    #endif
    @State private var reload: UUID?
    
    var url: URL?
    var width: Double?
    var height: Double?
    var aspectRatio: Double?
    var cornerRadius: Double = 0
    
    static var cacheAspect = [URL: CGFloat]()
    static let pipeline: ImagePipeline = {
        ImageCache.shared.costLimit = 1024 * 1024 * 150 //150mb memory cache
        
        var configuration = ImagePipeline.Configuration.withDataCache(
            name: "\(Bundle.main.bundleIdentifier!).thumbnail",
            sizeLimit: ImageCache.shared.costLimit
        )
        configuration.dataCachePolicy = .storeEncodedImages
        configuration.isDecompressionEnabled = true
        configuration.isRateLimiterEnabled = false
        return ImagePipeline(configuration: configuration)
    }()
        
    public init(
        _ url: URL? = nil,
        width: Double,
        height: Double,
        cornerRadius: Double = 0
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    public init(
        _ url: URL? = nil,
        width: Double,
        aspectRatio: Double? = nil,
        cornerRadius: Double = 0
    ) {
        self.url = url
        self.width = width
        self.aspectRatio = aspectRatio
        self.cornerRadius = cornerRadius
    }
    
    public init(
        _ url: URL? = nil,
        height: Double,
        aspectRatio: Double? = nil,
        cornerRadius: Double = 0
    ) {
        self.url = url
        self.height = height
        self.aspectRatio = aspectRatio
        self.cornerRadius = cornerRadius
    }
}

extension Thumbnail: View {
    var resize: ImageProcessors.Resize {
        if let width, let height {
            return .init(
                size: .init(width: width * displayScale, height: height * displayScale),
                contentMode: .aspectFill,
                crop: true
            )
        } else if let width {
            return .init(width: width * displayScale)
        } else if let height {
            return .init(height: height * displayScale)
        } else {
            let w = Double(Int(width ?? (height ?? 0) / (aspectRatio ?? 1)))
            let h = Double(Int(height ?? (width ?? 0) / (aspectRatio ?? 1)))
            return .init(
                size: .init(width: w * displayScale, height: h * displayScale),
                contentMode: .aspectFit,
                crop: true
            )
        }
    }
    
    var roundedCorner: ImageProcessors.RoundedCorners {
        .init(radius: cornerRadius)
    }
    
    func saveAspectRatio(_ result: ImageResponse) {
        guard let url, Self.cacheAspect[url] == nil
        else { return }
        
        Self.cacheAspect[url] = result.image.size.width / result.image.size.height
        reload = .init()
    }
    
    @MainActor
    var base: LazyImage<NukeUI.Image> {
        LazyImage(url: url)
            .animation(nil)
            .processors([resize, roundedCorner])
            .pipeline(Self.pipeline)
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
                .aspectRatio(aspectRatio, contentMode: .fill)
        }
        //downsampled
        else {
            base
                .onSuccess(saveAspectRatio)
                .aspectRatio(
                    url != nil ? Self.cacheAspect[url!] : 2,
                    contentMode: .fill
                )
                .tag(reload)
        }
    }
}


struct Thumbnail_Previews: PreviewProvider {
    static var url = URL(string: "https://p.calameoassets.com/210330110351-e4b885552abc85081417723d5999e906/p1.jpg")
    
    static var previews: some View {
        HStack {
            Thumbnail(url, width: 80, height: 60, cornerRadius: 3)
            
            Thumbnail(url, width: 24, height: 24, cornerRadius: 3)
            
            VStack {
                Thumbnail(url, width: 250, aspectRatio: 16/9)
                Text("Title")
                Text("Subtitle").foregroundStyle(.secondary)
            }
                .frame(width: 300)
                .background(.secondary)
            
            VStack {
                Thumbnail(url, width: 250)
                Text("Title")
                Text("Subtitle").foregroundStyle(.secondary)
            }
                .frame(width: 300)
                .background(.secondary)
        }
            .environment(\.colorScheme, .dark)
    }
}
