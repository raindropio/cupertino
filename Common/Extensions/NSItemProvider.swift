import Foundation
import UniformTypeIdentifiers
import UIKit

extension NSItemProvider: @unchecked Sendable { }

//MainActor is crutial to get some nsitems (from drag n drop)
@MainActor
extension Array where Element == NSItemProvider {
    public func getURLs(_ matching: [UTType]) async -> Set<URL> {
        var urls = Set<URL>()
        
        for item in self {
            //web url
            if matching.contains(.url),
               let url: URL = try? await item.loadObject(.url) {
                urls.insert(url)
            }
            //file url
            else if matching.contains(.fileURL),
                let url: URL = try? await item.loadObject(.fileURL),
                url.isValidFileURL {
                urls.insert(url)
            }
            //detect url's from text
            else if matching.contains(.url),
                let text: String = try? await item.loadObject(.text),
                !URL.detect(from: text).isEmpty {
                URL.detect(from: text).forEach { urls.insert($0) }
            }
            //image data
            else if matching.contains(.image),
                let image: UIImage = await item.getItem(UTType.image),
                let url = image.pngData()?.tempFile(item.suggestedName, ext: "png"){
                urls.insert(url)
            }
            //image object
            else if matching.contains(.image),
                item.hasItemConformingToTypeIdentifier(UTType.image.identifier),
                let image = (try? await item.loadObject(ofClass: UIImage.self)) as? UIImage,
                let url = image.pngData()?.tempFile(item.suggestedName, ext: "png"){
                urls.insert(url)
            }
            //pdf data
            else if matching.contains(.pdf),
                let data = try? await item.loadData(UTType.pdf),
                let url = data.tempFile(item.suggestedName, ext: "pdf"){
                urls.insert(url)
            }
        }
        
        return urls
    }
}

//MainActor is crutial to get some nsitems (from drag n drop)
@MainActor
extension NSItemProvider {
    public func getItem<T>(_ type: UTType) async -> T? {
        if hasItemConformingToTypeIdentifier(type.identifier) {
            let item = (try? await loadItem(forTypeIdentifier: type.identifier)) as? T
            return item
        }
        return nil
    }
    
    public func loadObject<T: _ObjectiveCBridgeable>(_ type: UTType) async throws -> T? where T._ObjectiveCType : NSItemProviderReading {
        try await withCheckedThrowingContinuation { continuation in
            if hasItemConformingToTypeIdentifier(type.identifier), canLoadObject(ofClass: T.self) {
                _ = loadObject(ofClass: T.self) { result, error in
                    if let result {
                        continuation.resume(returning: result)
                    } else if let error {
                        continuation.resume(throwing: error)
                    }
                }
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
    
    public func loadObject<T: _ObjectiveCBridgeable>(ofClass aClass: T.Type) async throws -> T? where T._ObjectiveCType : NSItemProviderReading {
        try await withCheckedThrowingContinuation { continuation in
            if canLoadObject(ofClass: aClass) {
                _ = loadObject(ofClass: aClass) { result, error in
                    if let result {
                        continuation.resume(returning: result)
                    } else if let error {
                        continuation.resume(throwing: error)
                    }
                }
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
    
    public func loadObject(ofClass aClass: NSItemProviderReading.Type) async throws -> NSItemProviderReading? {
        try await withCheckedThrowingContinuation { continuation in
            if canLoadObject(ofClass: aClass) {
                loadObject(ofClass: aClass) { result, error in
                    if let result {
                        continuation.resume(returning: result)
                    } else if let error {
                        continuation.resume(throwing: error)
                    }
                }
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
    
    public func loadData(_ type: UTType) async throws -> Data? {
        try await withCheckedThrowingContinuation { continuation in
            if hasItemConformingToTypeIdentifier(type.identifier) {
                loadDataRepresentation(forTypeIdentifier: type.identifier) { result, error in
                    if let result {
                        continuation.resume(returning: result)
                    } else if let error {
                        continuation.resume(throwing: error)
                    }
                }
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
}
