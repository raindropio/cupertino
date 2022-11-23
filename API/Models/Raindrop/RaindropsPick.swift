import Foundation

public enum RaindropsPick: Equatable {
    case all(FindBy)
    case some(Set<Raindrop.ID>)
}
