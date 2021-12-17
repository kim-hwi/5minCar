import Foundation
import RxSwift

final class SignUpUseCase {
    private let signUpService: SignUpServiceType
    
    init(service: SignUpServiceType = SignUpService()) {
        self.signUpService = service
    }
    
    func execute(with user: SignUpUser) -> Completable {
        return signUpService.request(of: user)
    }
    
    func isValid(id: String) -> IDCheckResult {
        let idRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return isValid(target: id, regEx: idRegEx) ? .valid : .invalid
    }

    func isValid(password: String) -> PasswordCheckResult {
        let passwordRegEx = "[a-zA-Z0-9!@#$%]{8,16}"
        return isValid(target: password, regEx: passwordRegEx) ? .valid : .invalid
    }
    
    func isValid(name: String) -> NameCheckResult {
        let nameRegEx = "[가-힣]{2,5}"
        return isValid(target: name, regEx: nameRegEx) ? .valid : .invalid
    }

    func isValid(nickName: String) -> NickNameCheckResult {
        let nickNameRegEx = "[가-힣a-zA-Z0-9_\\-]{1,20}"
        return isValid(target: nickName, regEx: nickNameRegEx) ? .valid : .invalid
    }
    
    private func isValid(target: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: target)
    }
}
