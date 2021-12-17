import Foundation

struct SignInUser: Codable {
    let id: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case id = "email"
        case password
    }
    
    init(id: String = "", password: String = "") {
        self.id = id
        self.password = password
    }
}
