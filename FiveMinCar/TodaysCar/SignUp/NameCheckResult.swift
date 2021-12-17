import Foundation

enum NameCheckResult {
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
            return "올바른 이름입니다."
        case .invalid:
            return "올바른 이름이 아닙니다."
        }
    }
}
