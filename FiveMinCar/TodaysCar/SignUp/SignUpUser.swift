import Foundation

struct SignUpUser: Codable {
    let id: String
    let name: String
    let password: String
    let nickName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "email"
        case name
        case password
        case nickName
    }
    
    init(id: String = "", name: String = "", password: String = "", nickName: String = "") {
        self.id = id
        self.name = name
        self.password = password
        self.nickName = nickName
    }
}
