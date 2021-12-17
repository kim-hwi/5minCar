import Foundation
import RxSwift
import Moya

final class SignInService: SignInServiceType {
    private let provider = MoyaProvider<SignInTarget>()
    
    func request(of user: SignInUser) -> Single<SignInResult> {
        return provider.rx
            .request(.signIn(user: user))
            .filterSuccessfulStatusCodes()
            .map(SignInResult.self)
    }
}
