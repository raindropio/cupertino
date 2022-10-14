import Foundation
import SwiftUI

public struct RaindropState: Equatable {
    @Cached("rns-items") var items = [Raindrop.ID: Raindrop]()
    
    typealias Groups = [ FindBy : Group ]
    @Cached("rns-groups", cachable) var groups = Groups()
}
