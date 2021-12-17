import Foundation
import RxSwift
import RxRelay

final class SignUpViewModel {
    let isValidID = PublishRelay<Bool>()
    let idCheckMessage = PublishRelay<String>()
    let isValidPassword = PublishRelay<Bool>()
    let passwordCheckMessage = PublishRelay<String>()
    let isValidName = PublishRelay<Bool>()
    let nameCheckMessage = PublishRelay<String>()
    let isValidNickName = PublishRelay<Bool>()
    let nickNameCheckMessage = PublishRelay<String>()
    let isValidSignUp = PublishRelay<Bool>()
    let signUpResultMessage = PublishRelay<String>()
    
    private let userID = PublishRelay<String>()
    private let userPassword = PublishRelay<String>()
    private let userName = PublishRelay<String>()
    private let userNickName = PublishRelay<String>()
    private let userType = PublishRelay<Int>()
    private let user = BehaviorRelay<SignUpUser>(value: SignUpUser())
    
    private let signUpUseCase = SignUpUseCase()
    private let disposeBag = DisposeBag()
    
    func viewDidLoad() {
        Observable
            .combineLatest(isValidID, isValidPassword, isValidName, isValidNickName)
            .map { $0 && $1 && $2 && $3 }
            .bind(to: isValidSignUp)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(userID, userName, userPassword, userNickName)
            .map { SignUpUser(id: $0, name: $1, password: $2, nickName: $3) }
            .bind(to: user)
            .disposed(by: disposeBag)
    }
    
    func didEnter(id: String) {
        let result = signUpUseCase.isValid(id: id)
        isValidID.accept(result.isValid)
        idCheckMessage.accept(result.message)
        userID.accept(id)
    }
    
    func didEnter(password: String) {
        let result = signUpUseCase.isValid(password: password)
        isValidPassword.accept(result.isValid)
        passwordCheckMessage.accept(result.message)
        userPassword.accept(password)
    }
    
    func didEnter(name: String) {
        let result = signUpUseCase.isValid(name: name)
        isValidName.accept(result.isValid)
        nameCheckMessage.accept(result.message)
        userName.accept(name)
    }
    
    func didEnter(nickName: String) {
        let result = signUpUseCase.isValid(nickName: nickName)
        isValidNickName.accept(result.isValid)
        nickNameCheckMessage.accept(result.message)
        userNickName.accept(nickName)
    }
    
    func didSelect(type: Int) {
        userType.accept(type)
    }
    
    func didTapSignUp() {
        signUpUseCase.execute(with: user.value)
            .subscribe(onCompleted: { [weak self] in
                self?.signUpResultMessage.accept("회원가입 완료!")
            }, onError: { [weak self] _ in
                self?.signUpResultMessage.accept("회원가입 오류!")
            })
            .disposed(by: disposeBag)
    }
}
