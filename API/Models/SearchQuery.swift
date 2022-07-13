public struct SearchQuery: Hashable {
    public var text: String = ""
    public var tokens: [SearchToken] = []
    
    public var isEmpty: Bool {
        text.isEmpty && tokens.isEmpty
    }
    
    public init() {}
    
    public init(tokens: [SearchToken]) {
        self.tokens = tokens
    }

    public init(text: String, tokens: [SearchToken]) {
        self.text = text
        self.tokens = tokens
    }
}
