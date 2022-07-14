public struct SearchQuery: Hashable {
    public var text: String = ""
    public var tokens: [SearchToken] = []
    
    //MARK: - Init
    public init() {}
    
    public init(tokens: [SearchToken]) {
        self.tokens = tokens
    }

    public init(text: String, tokens: [SearchToken]) {
        self.text = text
        self.tokens = tokens
    }
    
    //MARK: - Helpers
    public var isEmpty: Bool {
        text.isEmpty && tokens.isEmpty
    }
    
    public var title: String {
        "\(tokens.isEmpty ? "" : (tokens.map{ $0.title }.joined(separator: " ") + " "))\(text)"
    }
}
