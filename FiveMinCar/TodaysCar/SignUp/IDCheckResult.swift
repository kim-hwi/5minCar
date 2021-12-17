import Foundation

enum IDCheckResult {
    case valid
    case invalid
    
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
    
    var message: String {
        switch self {
        case .valid:
            return "올바른 아이디 형식입니다."
        case .invalid:
            return "올바른 아이디 형식이 아닙니다."
        }
    }
}
