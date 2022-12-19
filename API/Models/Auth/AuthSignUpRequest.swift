public struct AuthSignUpRequest: Encodable {
    public var name: String
    public var email: String
    public var password: String
    
    public init(name: String = "", email: String = "", password: String = "") {
        self.name = name
        self.email = email
        self.password = password
    }
    
    public var isValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    public var isEmpty: Bool {
        name.isEmpty && email.isEmpty && password.isEmpty
    }
}
