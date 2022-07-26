import Foundation
import UniformTypeIdentifiers
import SwiftUI

public struct Raindrop: Identifiable, Hashable, Codable {
    public var id: Int
    public var link: URL
    public var title: String
}

extension UTType {
    public static var raindrop = UTType(exportedAs: "\(Bundle.main.bundleIdentifier!).raindrop")
}

//@available(macOS 13.0, *)
//extension Raindrop: Transferable {
//    public static var transferRepresentation: some TransferRepresentation {
//        CodableRepresentation(for: Self.self, contentType: .raindrop)
//        ProxyRepresentation(exporting: \.link)
//    }
//}

//MARK: - Preview
public extension Raindrop {
    static var preview = [
        Raindrop(id: 272043111, link: URL(string: "https://sarunw.com/posts/swiftui-menu-bar-app/")!, title: "Челленджи в TMNT: Shredder’s Revenge"),
        Raindrop(id: 376070368, link: URL(string: "https://swiftwithmajid.com/2020/09/02/displaying-recursive-data-using-outlinegroup-in-swiftui/")!, title: "IQUNIX ZX-1 Aluminum Mini-ITX Case"),
        Raindrop(id: 417975426, link: URL(string: "https://link.medium.com/iMdQVselJrb")!, title: "SwiftUI: How to create your custom notification event and receive the event! Advanced Technique"),
        Raindrop(id: 417800125, link: URL(string: "https://nilcoalescing.com/blog/AdaptiveLayoutsWithViewThatFits/")!, title: "ERROR: The request could not be satisfied"),
        Raindrop(id: 416060386, link: URL(string: "https://swiftwithmajid.com/2022/06/28/the-power-of-task-view-modifier-in-swiftui/")!, title: "The power of task view modifier in SwiftUI"),
        Raindrop(id: 415988215, link: URL(string: "https://www.getupnext.com/")!, title: "Upnext - Save anything, and actually get to it later")
    ]
}
