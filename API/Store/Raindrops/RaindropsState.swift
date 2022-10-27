import Foundation
import SwiftUI

public struct RaindropsState: Equatable {
    typealias Segments = [ FindBy : Segment ]

    @Cached("rns-items") var items = [Raindrop.ID: Raindrop]()
    @Cached("rns-segments", cachable) var segments = Segments()
}
