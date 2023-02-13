import Foundation
import API

public enum DeepLinkDestination: Equatable {
    case raindrop(R)
    public enum R: Equatable {
        case open(Raindrop.ID)
        case preview(Raindrop.ID)
        case cache(Raindrop.ID)
    }
    
    case collection(C)
    public enum C: Equatable {
        case open(UserCollection.ID)
    }
    
    case find(FindBy)
}
