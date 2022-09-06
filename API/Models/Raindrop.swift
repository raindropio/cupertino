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
        Raindrop(id: 415988215, link: URL(string: "https://www.getupnext.com/")!, title: "Upnext - Save anything, and actually get to it later", cover: URL(string: "https://cdn.vox-cdn.com/thumbor/h01UekLpodxIkpU7k2xQK7N8DlQ=/0x0:2154x1436/1820x1213/filters:focal(905x546:1249x890):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/71162778/devices_2154_e823c124b9b3c47a72530fe51f472ed4.0.jpg")!),
        Raindrop(id: 217135569, link: URL(string: "https://thegrowthlist.co")!, title: "GrowthList", cover: URL(string: "https://uploads-ssl.webflow.com/5e5918651c2c93508dd3bab8/5fb94bffd2fdf118c7cc2eb9_Capture%20d%E2%80%99e%CC%81cran%202020-11-21%20a%CC%80%2018.18.18.png")!),
        Raindrop(id: 198301029, link: URL(string: "https://canny.io/blog/how-we-built-a-1m-arr-saas-startup")!, title: "How we built a $1m ARR SaaS startup", cover: URL(string: "https://canny.io/blog/wp-content/uploads/2020/09/1m-arr-featured.jpg")!),
        Raindrop(id: 53524355, link: URL(string: "https://stripe.com/atlas/guides/tax-season")!, title: "Stripe: Atlas Guide to Tax Season", cover: URL(string: "https://stripe.com/img/v3/atlas/guide/social.png")!),
        Raindrop(id: 22297916, link: URL(string: "https://nilcoalescing.com/blog/AdaptiveLayoutsWithViewThatFits/")!, title: "FbStart", cover: URL(string: "http://s2.wp.com/wp-content/themes/vip/facebook-start/img/logo.jpg?m=1417765343h")!),
        Raindrop(id: 75649813, link: URL(string: "https://paddle.com/")!, title: "Paddle - The better way to sell software", cover: URL(string: "https://images.prismic.io/paddle/4168aa5d-7c2d-4d66-8179-7a9b6360e4cd_Group+840.png?auto=compress,format&rect=51,0,3860,1900&w=1280&h=630")!),
        Raindrop(id: 82906639, link: URL(string: "https://gumroad.com/")!, title: "Gumroad", cover: URL(string: "https://assets.gumroad.com/assets/brand/g-transparent-512-ee5909cb09aded26608f69228404591536fdcb38d73ef7aeb0235db3201fad97.png")!)
    ]
}
