import Foundation

public struct User: Identifiable, Equatable, Hashable {
    public var id: Int
    public var name: String
    public var email = ""
    public var avatar: URL?
    public var pro = false
    public var registered: Date
    public var password = false
    public var files = Files()
    
    public var apple = Connect()
    public var google = Connect()
    public var facebook = Connect()
    public var twitter = Connect()
    public var vkontakte = Connect()
    public var dropbox = Connect()
    public var gdrive = Connect()
}
