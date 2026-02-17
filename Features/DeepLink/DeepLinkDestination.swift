import Foundation
import API

public enum DeepLinkDestination: Equatable {
    case raindrop(R)
    public enum R: Equatable {
        case open(FindBy, Raindrop.ID)
        case preview(FindBy, Raindrop.ID)
        case cache(Raindrop.ID)
    }
    
    case collection(C)
    public enum C: Equatable {
        case open(UserCollection.ID)
    }
    
    case find(FindBy)
    
    case settings(S? = nil)
    public enum S: Equatable {
        case extensions
    }
    
    case ask
}
