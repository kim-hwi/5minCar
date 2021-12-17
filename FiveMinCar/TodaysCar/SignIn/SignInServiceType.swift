import Foundation
import RxSwift

protocol SignInServiceType {
    func request(of user: SignInUser) -> Single<SignInResult>
}
