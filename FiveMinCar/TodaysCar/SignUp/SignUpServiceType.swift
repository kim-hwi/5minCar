import Foundation
import RxSwift

protocol SignUpServiceType {
    func request(of user: SignUpUser) -> Completable
}
