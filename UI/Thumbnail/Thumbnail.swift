import SwiftUI
import Nuke
import NukeUI

#if os(macOS)
fileprivate let scaleFactor: CGFloat = NSScreen.main?.backingScaleFactor ?? 1
#else
fileprivate let scaleFactor: CGFloat = 1
#endif

fileprivate var aspectCache: [URL: CGFloat] = [:]

public struct Thumbnail {
    var url: URL?
    var width: CGFloat?
    var height: CGFloat?
    var aspectRatio: CGFloat?
    
    static let pipeline: ImagePipeline = {
        var configuration = ImagePipeline.Configuration.withDataCache(
            name: "\(Bundle.main.bundleIdentifier!).thumbnail",
            sizeLimit: 1024 * 1024 * 1000 //1000mb disk cache
        )
        configuration.dataCachePolicy = .storeAll
        configuration.isDecompressionEnabled = true
        configuration.isUsingPrepareForDisplay = true
        configuration.isRateLimiterEnabled = false
        configuration.isProgressiveDecodingEnabled = true
        
        configuration.dataLoadingQueue.maxConcurrentOperationCount = 100
        configuration.imageDecodingQueue.maxConcurrentOperationCount = 100
        configuration.imageEncodingQueue.maxConcurrentOperationCount = 100
        configuration.imageProcessingQueue.maxConcurrentOperationCount = 100
        configuration.imageDecompressingQueue.maxConcurrentOperationCount = 100
        
        return .init(configuration: configuration)
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
        aspectRatio: CGFloat? = nil
    ) {
        self.url = url
        self.width = width
        self.aspectRatio = aspectRatio
    }
    
    public init(
        _ url: URL? = nil,
        height: Double,
        aspectRatio: CGFloat? = nil
    ) {
        self.url = url
        self.height = height
        self.aspectRatio = aspectRatio
    }
    
    public init(
        _ url: URL? = nil
    ) {
        self.url = url
    }
}

extension Thumbnail: Equatable {
    
}

extension Thumbnail {
    private var resize: [ImageProcessors.Resize] {
        if let width, let height {
            return [.init(size: .init(width: width * scaleFactor, height: height * scaleFactor), crop: true)]
        } else if let width {
            return [.init(width: width * scaleFactor)]
        } else if let height {
            return [.init(height: height * scaleFactor)]
        }
        return []
    }
    
    private func onCompletion(_ result: Result<ImageResponse, Error>) {
        switch result {
        case .success(let res):
            if aspectRatio == nil, let url {
                aspectCache[url] = res.image.size.width / res.image.size.height
            }
        default:
            return
        }
    }
}

extension Thumbnail: View {
    public var body: some View {
        ZStack {
            LazyImage(request: .init(url: url, processors: resize)) {
                if let image = $0.image {
                    image
                        .resizable()
                        .antialiased(false)
                        .interpolation(.low)
                        .scaledToFill()
                } else if $0.error != nil {
                    if (width != nil && height != nil) || aspectRatio != nil {
                        Color.primary.opacity(0.1)
                    }
                } else if aspectRatio == nil, let url, let ar = aspectCache[url] {
                    Rectangle().fill(.clear).aspectRatio(ar, contentMode: .fit)
                }
            }
                .pipeline(Self.pipeline)
                .onDisappear(.lowerPriority)
                .onCompletion(onCompletion)
                .layoutPriority(-1)
            
            Group {
                if let width, let height {
                    Color.clear.frame(width: width, height: height)
                } else if let aspectRatio {
                    Color.clear.aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
                .fixedSize(horizontal: width == nil, vertical: height == nil)
        }
            .clipped()
    }
}
