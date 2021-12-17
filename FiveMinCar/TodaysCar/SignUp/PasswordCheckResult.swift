import Foundation

enum PasswordCheckResult {
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
            return "올바른 비밀번호입니다."
        case .invalid:
            return "올바른 비밀번호가 아닙니다."
        }
    }
}
