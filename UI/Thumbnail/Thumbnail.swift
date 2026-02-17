import SwiftUI
import Kingfisher
import os

#if os(macOS)
fileprivate var scaleFactor: CGFloat { NSScreen.main?.backingScaleFactor ?? 1 }
#else
fileprivate var scaleFactor: CGFloat { UIScreen.main.scale }
#endif

fileprivate let aspectCache = OSAllocatedUnfairLock(initialState: [URL: CGFloat]())

public struct Thumbnail {
    var url: URL?
    var width: CGFloat?
    var height: CGFloat?
    var aspectRatio: CGFloat?

    public init(_ url: URL? = nil, width: Double, height: Double) {
        self.url = url
        self.width = width
        self.height = height
    }

    public init(_ url: URL? = nil, width: Double, aspectRatio: CGFloat? = nil) {
        self.url = url
        self.width = width
        self.aspectRatio = aspectRatio
    }

    public init(_ url: URL? = nil, height: Double, aspectRatio: CGFloat? = nil) {
        self.url = url
        self.height = height
        self.aspectRatio = aspectRatio
    }

    public init(_ url: URL? = nil) {
        self.url = url
    }
}

extension Thumbnail: Equatable {}

extension Thumbnail: View {
    public var body: some View {
        ZStack {
            KFImage(url)
                .setProcessor(processor)
                .cancelOnDisappear(true)
                .loadDiskFileSynchronously()
                .onSuccess(onSuccess)
                .placeholder {
                    if (width != nil && height != nil) || aspectRatio != nil {
                        Color.primary.opacity(0.1)
                    }
                }
                .resizable()
                .interpolation(.low)
                .antialiased(false)
                .scaledToFill()
                .layoutPriority(-1)

            Group {
                if let width, let height {
                    Color.clear.frame(width: width, height: height)
                } else if let aspectRatio {
                    Color.clear.aspectRatio(aspectRatio, contentMode: .fit)
                } else if let url, let ar = aspectCache.withLock({ $0[url] }) {
                    Color.clear.aspectRatio(ar, contentMode: .fit)
                }
            }
            .fixedSize(horizontal: width == nil, vertical: height == nil)
        }
        .clipped()
    }
    
    private func onSuccess(_ result: RetrieveImageResult) {
        if aspectRatio == nil, let url {
            aspectCache.withLock { $0[url] = result.image.size.width / result.image.size.height }
        }
    }

    private var processor: ImageProcessor {
        if let width, let height {
            return DownsamplingImageProcessor(size: CGSize(width: width * scaleFactor, height: height * scaleFactor))
        } else if let width {
            return DownsamplingImageProcessor(size: CGSize(width: width * scaleFactor, height: .greatestFiniteMagnitude))
        } else if let height {
            return DownsamplingImageProcessor(size: CGSize(width: .greatestFiniteMagnitude, height: height * scaleFactor))
        } else {
            return DefaultImageProcessor.default
        }
    }
}
