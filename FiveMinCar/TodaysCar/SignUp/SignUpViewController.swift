import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var idCheckLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordCheckLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var nameCheckLabel: UILabel!
    @IBOutlet private weak var nickNameTextField: UITextField!
    @IBOutlet private weak var nickNameCheckLabel: UILabel!
    @IBOutlet private weak var userTypeSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var signUpButton: UIButton!
    
    private let viewModel = SignUpViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        bindKeyboard(at: disposeBag)
        bindInput()
        bindOutput()
    }
    
    private func bindInput() {
        backButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        idTextField.rx.text
            .orEmpty
            .changed
            .bind(onNext: { [weak self] in
                self?.viewModel.didEnter(id: $0)
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .changed
            .bind(onNext: { [weak self] in
                self?.viewModel.didEnter(password: $0)
            })
            .disposed(by: disposeBag)
        
        nameTextField.rx.text
            .orEmpty
            .changed
            .bind(onNext: { [weak self] in
                self?.viewModel.didEnter(name: $0)
            })
            .disposed(by: disposeBag)
        
        nickNameTextField.rx.text
            .orEmpty
            .changed
            .bind(onNext: { [weak self] in
                self?.viewModel.didEnter(nickName: $0)
            })
            .disposed(by: disposeBag)
        
        userTypeSegmentedControl.rx.value
            .changed
            .bind(onNext: { [weak self] in
                self?.viewModel.didSelect(type: $0)
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.viewModel.didTapSignUp()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.isValidID
            .map { $0 ? .systemGreen : .systemRed }
            .bind(to: idCheckLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.idCheckMessage
            .bind(to: idCheckLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isValidPassword
            .map { $0 ? .systemGreen : .systemRed }
            .bind(to: passwordCheckLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.passwordCheckMessage
            .bind(to: passwordCheckLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isValidName
            .map { $0 ? .systemGreen : .systemRed }
            .bind(to: nameCheckLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.nameCheckMessage
            .bind(to: nameCheckLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isValidNickName
            .map { $0 ? .systemGreen : .systemRed }
            .bind(to: nickNameCheckLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        viewModel.nickNameCheckMessage
            .bind(to: nickNameCheckLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isValidSignUp
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.signUpResultMessage
            .bind(onNext: { [weak self] in
                self?.showAlert(with: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert(with title: String) {
        let alertViewController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
        alertViewController.addAction(alertAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
}
