import Foundation
import UniformTypeIdentifiers
import SwiftUI

public struct Raindrop: Identifiable, Hashable, Codable {
    public var id: Int
    public var link: URL
    public var title: String
    public var excerpt: String = ""
    public var cover: URL?
    public var created: Date = Date()
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
        Raindrop(id: 272043111, link: URL(string: "https://sarunw.com/posts/swiftui-menu-bar-app/")!, title: "Челленджи в TMNT: Shredder’s Revenge", excerpt: "Teenage Mutant Ninja Turtles: Shredder’s Revenge features groundbreaking gameplay rooted in timeless classic brawling mechanics, brought to you by the beat ’em up experts at Dotemu (Streets of Rage 4) and Tribute Games", cover: URL(string: "https://rdl.ink/render/https%3A%2F%2Fwww.shredders-revenge.com%2F")!),
        Raindrop(id: 376070368, link: URL(string: "https://swiftwithmajid.com/2020/09/02/displaying-recursive-data-using-outlinegroup-in-swiftui/")!, title: "IQUNIX ZX-1 Aluminum Mini-ITX Case", excerpt: "New Arrivial! IQUNIX ZX-1 Mini-ITX Case is now available in new theme colorways. Best pc cases we offer then look no further as IQUNIX offers water cooling and air cooling versions with the best aluminum material. Grab one of our new mechanical keyboards available at IQUNIX store.", cover: URL(string: "https://cdn.shopify.com/s/files/1/1183/1328/products/ITX-Post_1200x630.jpg")!, created: .init(timeIntervalSince1970: 1597269862.9328)),
        Raindrop(id: 417975426, link: URL(string: "https://link.medium.com/iMdQVselJrb")!, title: "SwiftUI: How to create your custom notification event and receive the event! Advanced Technique", excerpt: "As the name implies, a property wrapper is a new type that wraps a property to add additional logic. Let's see what it capable of and the benefit it provided.", cover: URL(string: "https://miro.medium.com/max/890/1*IIw0XgNh6wZ1X4jHyRTFiA.jpeg")!),
        Raindrop(id: 417800125, link: URL(string: "https://nilcoalescing.com/blog/AdaptiveLayoutsWithViewThatFits/")!, title: "ERROR: The request could not be satisfied", excerpt: "", cover: URL(string: "https://nilcoalescing.com/static/blog/AdaptiveLayoutsWithViewThatFits/banner.Pvzv0hCL-Jr4w7ekKc0cmAoiu2bVp87KLIPYhkHuNRk.png")!),
        Raindrop(id: 416060386, link: URL(string: "https://swiftwithmajid.com/2022/06/28/the-power-of-task-view-modifier-in-swiftui/")!, title: "The power of task view modifier in SwiftUI", excerpt: "What comes to mind when you think of Notification? Just think for 3 seconds. When many developers hear the word “notification”, they think…", cover: URL(string: "https://swiftwithmajid.com/public/swiftui.png")!),
        Raindrop(id: 415988215, link: URL(string: "https://www.getupnext.com/")!, title: "Upnext - Save anything, and actually get to it later", excerpt: "Upnext is a radically better reader. Save anything in the moment, get through what's relevant later and share what you discovered with others.", cover: URL(string: "https://uploads-ssl.webflow.com/5edeb0e6c233e0191ba539a1/62cc005c6cdaeb3b24c983fa_ActuallyGetToIt.png")!),
        Raindrop(id: 217135569, link: URL(string: "https://thegrowthlist.co")!, title: "GrowthList", excerpt: "GrowthList is the go-to resource hub for tech-savvy marketers in fast-growing companies. Find hundred of Growth Hacks to boost your startup!", cover: URL(string: "https://uploads-ssl.webflow.com/5e5918651c2c93508dd3bab8/5fb94bffd2fdf118c7cc2eb9_Capture%20d%E2%80%99e%CC%81cran%202020-11-21%20a%CC%80%2018.18.18.png")!),
        Raindrop(id: 198301029, link: URL(string: "https://canny.io/blog/how-we-built-a-1m-arr-saas-startup")!, title: "How we built a $1m ARR SaaS startup", excerpt: "Canny recently hit a major milestone: one million dollars in annual recurring revenue. Here's how we built a $1m ARR SaaS startup from the ground up.", cover: URL(string: "https://canny.io/blog/wp-content/uploads/2020/09/1m-arr-featured.jpg")!),
        Raindrop(id: 53524355, link: URL(string: "https://stripe.com/atlas/guides/tax-season")!, title: "Stripe: Atlas Guide to Tax Season", excerpt: "Atlas’ guide to U.S. income taxes, Delaware franchise tax, and other taxes relevant to your business.", cover: URL(string: "https://stripe.com/img/v3/atlas/guide/social.png")!),
        Raindrop(id: 22297916, link: URL(string: "https://nilcoalescing.com/blog/AdaptiveLayoutsWithViewThatFits/")!, title: "FbStart", excerpt: "FbStart provides startups with an exclusive community, worldwide events, mentorship from Facebook, a...", cover: URL(string: "http://s2.wp.com/wp-content/themes/vip/facebook-start/img/logo.jpg?m=1417765343h")!),
        Raindrop(id: 75649813, link: URL(string: "https://paddle.com/")!, title: "Paddle - The better way to sell software", excerpt: "We provide everything you need to sell software in one integration, with advanced solutions to help you grow and optimize your software business.", cover: URL(string: "https://images.prismic.io/paddle/4168aa5d-7c2d-4d66-8179-7a9b6360e4cd_Group+840.png?auto=compress,format&rect=51,0,3860,1900&w=1280&h=630")!),
        Raindrop(id: 82906639, link: URL(string: "https://gumroad.com/")!, title: "Gumroad", excerpt: "Sell music, comics, software, books, and films directly to your audience.", cover: URL(string: "https://assets.gumroad.com/assets/brand/g-transparent-512-ee5909cb09aded26608f69228404591536fdcb38d73ef7aeb0235db3201fad97.png")!, created: .init(timeIntervalSince1970: 1597269862.9328))
    ]
}
