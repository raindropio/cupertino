import Foundation
import UniformTypeIdentifiers
import SwiftUI

public struct Raindrop: Identifiable, Hashable, Codable {
    public var id: Int
    public var link: URL
    public var title: String
    public var cover: URL
}

extension UTType {
    public static var raindrop = UTType(exportedAs: "\(Bundle.main.bundleIdentifier!).raindrop")
}

extension Raindrop: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .raindrop)
        DataRepresentation(exportedContentType: .url) {
            $0.link.dataRepresentation
        }
        ProxyRepresentation(exporting: \.title)
    }
}

//extension Raindrop {
//    public var sharePreview: SharePreview<Never, AsyncImage<Never>> {
//        .init(title, icon: AsyncImage(url: cover))
//    }
//}

//MARK: - Preview
public extension Raindrop {
    static var preview = [
        Raindrop(id: 272043111, link: URL(string: "https://sarunw.com/posts/swiftui-menu-bar-app/")!, title: "Челленджи в TMNT: Shredder’s Revenge", cover: URL(string: "https://cdn.vox-cdn.com/thumbor/h01UekLpodxIkpU7k2xQK7N8DlQ=/0x0:2154x1436/1820x1213/filters:focal(905x546:1249x890):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/71162778/devices_2154_e823c124b9b3c47a72530fe51f472ed4.0.jpg")!),
        Raindrop(id: 376070368, link: URL(string: "https://swiftwithmajid.com/2020/09/02/displaying-recursive-data-using-outlinegroup-in-swiftui/")!, title: "IQUNIX ZX-1 Aluminum Mini-ITX Case", cover: URL(string: "https://cdn.vox-cdn.com/thumbor/h01UekLpodxIkpU7k2xQK7N8DlQ=/0x0:2154x1436/1820x1213/filters:focal(905x546:1249x890):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/71162778/devices_2154_e823c124b9b3c47a72530fe51f472ed4.0.jpg")!),
        Raindrop(id: 417975426, link: URL(string: "https://link.medium.com/iMdQVselJrb")!, title: "SwiftUI: How to create your custom notification event and receive the event! Advanced Technique", cover: URL(string: "https://cdn.vox-cdn.com/thumbor/h01UekLpodxIkpU7k2xQK7N8DlQ=/0x0:2154x1436/1820x1213/filters:focal(905x546:1249x890):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/71162778/devices_2154_e823c124b9b3c47a72530fe51f472ed4.0.jpg")!),
        Raindrop(id: 417800125, link: URL(string: "https://nilcoalescing.com/blog/AdaptiveLayoutsWithViewThatFits/")!, title: "ERROR: The request could not be satisfied", cover: URL(string: "https://cdn.vox-cdn.com/thumbor/h01UekLpodxIkpU7k2xQK7N8DlQ=/0x0:2154x1436/1820x1213/filters:focal(905x546:1249x890):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/71162778/devices_2154_e823c124b9b3c47a72530fe51f472ed4.0.jpg")!),
        Raindrop(id: 416060386, link: URL(string: "https://swiftwithmajid.com/2022/06/28/the-power-of-task-view-modifier-in-swiftui/")!, title: "The power of task view modifier in SwiftUI", cover: URL(string: "https://cdn.vox-cdn.com/thumbor/h01UekLpodxIkpU7k2xQK7N8DlQ=/0x0:2154x1436/1820x1213/filters:focal(905x546:1249x890):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/71162778/devices_2154_e823c124b9b3c47a72530fe51f472ed4.0.jpg")!),
        Raindrop(id: 415988215, link: URL(string: "https://www.getupnext.com/")!, title: "Upnext - Save anything, and actually get to it later", cover: URL(string: "https://cdn.vox-cdn.com/thumbor/h01UekLpodxIkpU7k2xQK7N8DlQ=/0x0:2154x1436/1820x1213/filters:focal(905x546:1249x890):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/71162778/devices_2154_e823c124b9b3c47a72530fe51f472ed4.0.jpg")!)
    ]
}
