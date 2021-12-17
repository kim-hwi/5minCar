import Foundation

struct SignInResult: Codable {
    let code: Int
    let message: String
    let data: SignInData
}

struct SignInData: Codable {
    let token: String
    let name: String
}
