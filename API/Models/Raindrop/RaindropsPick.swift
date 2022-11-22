import Foundation

public enum RaindropsPick: Equatable {
    case all(FindBy)
    case some([Raindrop.ID])
}
