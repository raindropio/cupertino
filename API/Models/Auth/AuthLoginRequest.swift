public struct AuthLoginRequest: Encodable {
    public var email: String
    public var password: String
    
    public init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
    }
    
    public var isValid: Bool {
        !email.isEmpty && !password.isEmpty
    }
}
