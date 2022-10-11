extension Store {
    public enum Action {
        case restore
        case reset
        
        case filters(FiltersAction)
        case raindrop(RaindropAction)
        case raindrops(RaindropsAction)
        case user(UserAction)
    }
    
    public enum FiltersAction {
        case load(FindBy)
        case fetch(FindBy)
    }
    
    public enum RaindropAction {
        case create(Raindrop) // -> raindrops(.create([Raindrop]))
    }
    
    public enum RaindropsAction {
        case load(FindBy)
        case fetch(FindBy)
        case nextPage(FindBy)
        
        case create([Raindrop])
    }
    
    public enum UserAction {
        case load
        case fetch
        case logout
    }
}
