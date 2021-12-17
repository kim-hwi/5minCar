import Foundation
import RxSwift

final class SignInUseCase {
    @UserDefault(key: "token") static var token: String
    
    private let signInService: SignInServiceType
    
    init(service: SignInServiceType = SignInService()) {
        self.signInService = service
    }
    
    func execute(with user: SignInUser) -> Completable {
        return signInService.request(of: user)
            .do { SignInUseCase.token = $0.data.token }
            .asCompletable()
    }
}
