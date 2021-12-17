import Foundation
import Moya

enum SignUpTarget {
    case signUp(user: Codable)
}

extension SignUpTarget: TargetType {
    var baseURL: URL {
        return URL(string: "http://3.38.213.148:8333")!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/user/signup"
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .signUp(let user):
            return .requestJSONEncodable(user)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
