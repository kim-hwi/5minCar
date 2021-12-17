import Foundation
import Moya

enum SignInTarget {
    case signIn(user: Codable)
}

extension SignInTarget: TargetType {
    var baseURL: URL {
        return URL(string: "http://3.38.213.148:8333")!
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/user/signin"
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var method: Moya.Method {
        switch self {
        case .signIn:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signIn(let user):
            return .requestJSONEncodable(user)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
