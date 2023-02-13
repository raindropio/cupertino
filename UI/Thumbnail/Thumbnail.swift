import SwiftUI
import Nuke
import NukeUI

public struct Thumbnail {
    @State private var reload: UUID?
    
    var url: URL?
    var width: CGFloat?
    var height: CGFloat?
    var aspectRatio: Double?
    
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
        height: Double
    ) {
        self.url = url
        self.width = width
        self.height = height
    }
    
    public init(
        _ url: URL? = nil,
        width: Double,
        aspectRatio: Double? = nil
    ) {
        self.url = url
        self.width = width
        self.aspectRatio = aspectRatio
    }
    
    public init(
        _ url: URL? = nil,
        height: Double,
        aspectRatio: Double? = nil
    ) {
        self.url = url
        self.height = height
        self.aspectRatio = aspectRatio
    }
}

extension Thumbnail: View {
    var resize: [ImageProcessors.Resize]? {
        if let width, let height {
            return [.init(
                size: .init(width: width, height: height),
                unit: .points,
                crop: true
            )]
        } else if let width {
            return [.init(width: width, unit: .points)]
        } else if let height {
            return [.init(height: height, unit: .points)]
        }
        return nil
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
            .processors(resize)
            .pipeline(Self.pipeline)
//            .priority(.veryLow)
            .onDisappear(.lowerPriority)
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
            ZStack {
                base.layoutPriority(-1)
                Color.clear.aspectRatio(aspectRatio, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: width == nil, vertical: height == nil)
            }
        }
        //downsampled
        else {
            base
                .onSuccess(saveAspectRatio)
                .aspectRatio(
                    url != nil ? Self.cacheAspect[url!] : 1.77,
                    contentMode: .fit
                )
                .frame(height: height)
                .fixedSize(horizontal: width == nil, vertical: height == nil)
                .tag(reload)
        }
    }
}


struct Thumbnail_Previews: PreviewProvider {
    struct P: View {
        @State private var selection: Set<URL> = .init()

        var items = [
            Item(id: URL(string: "https://rdl.ink/render/https%3A%2F%2Fpublic-files.gumroad.com%2Fvariants%2Fd4aj5t65fudxb6na9slqtnmldtb8%2Fbaaca0eb0e33dc4f9d45910b8c86623f0144cea0fe0c2093c546d17d535752eb?width=1000&height=1000&dpr=3")!),
            Item(id: URL(string: "https://rdl.ink/render/https%3A%2F%2Fd2pas86kykpvmq.cloudfront.net%2Ftwitter%2Fabstract.png?width=1000&height=1000&dpr=3")!),
            Item(id: URL(string: "https://rdl.ink/render/https%3A%2F%2Fuploads-ssl.webflow.com%2F60bf6532b298ace2d2bb8a9d%2F629739f69a2044612aa77212_OG%2520image%2520(1200-630).jpg?width=1000&height=1000&dpr=3")!),
            Item(id: URL(string: "https://rdl.ink/render/https%3A%2F%2Ffffuel.co%2Fimages%2Fcover.png?width=1000&height=1000&dpr=3")!),
            Item(id: URL(string: "https://rdl.ink/render/https%3A%2F%2Fup.raindrop.io%2Fraindrop%2Ffiles%2F126%2F906%2F55%2F12690655.jpg?width=1000&height=1000&dpr=3")!)
        ]
        
        struct Item: Identifiable {
            var id: URL
        }
        
        var body: some View {
            LazyStack(.grid(250, true), selection: $selection) { _ in
                
            } content: {
                DataSource(items) { item in
                    VStack(alignment: .leading, spacing: 0) {
                        Thumbnail(item.id, width: 250)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.id.absoluteString)
                            Text(item.id.absoluteString)
//                            Spacer(minLength: 0)
                            Text("Footer")
                        }
                    }
                } loadMore: {}
            }
        }
    }
    
    static var previews: some View {
        P()
    }
}
