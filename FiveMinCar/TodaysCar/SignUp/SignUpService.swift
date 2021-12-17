import Foundation
import RxSwift
import Moya

final class SignUpService: SignUpServiceType {
    private let provider = MoyaProvider<SignUpTarget>()
    
    func request(of user: SignUpUser) -> Completable {
        return provider.rx
            .request(.signUp(user: user))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
}
