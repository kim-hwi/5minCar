import Foundation
import RxSwift
import RxRelay

final class SignInViewModel {
    let signInResultMessage = PublishRelay<(Bool, String)>()
    
    private let userID = PublishRelay<String>()
    private let userPassword = PublishRelay<String>()
    private let user = BehaviorRelay<SignInUser>(value: SignInUser())
    
    private let signInUseCase = SignInUseCase()
    private let disposeBag = DisposeBag()
    
    func viewDidLoad() {
        Observable
            .combineLatest(userID, userPassword)
            .map { SignInUser(id: $0, password: $1) }
            .bind(to: user)
            .disposed(by: disposeBag)
    }
    
    func didEnter(id: String) {
        userID.accept(id)
    }
    
    func didEnter(password: String) {
        userPassword.accept(password)
    }
    
    func didTapSignIn() {
        signInUseCase.execute(with: user.value)
            .subscribe(onCompleted: { [weak self] in
                self?.signInResultMessage.accept((true, "로그인 완료!"))
            }, onError: { [weak self] _ in
                self?.signInResultMessage.accept((false, "로그인 실패!"))
            })
            .disposed(by: disposeBag)
    }
}
