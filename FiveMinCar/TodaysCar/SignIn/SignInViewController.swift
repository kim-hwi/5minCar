import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    
    private let viewModel = SignInViewModel()
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
        
        signInButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.viewModel.didTapSignIn()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.signInResultMessage
            .bind(onNext: { [weak self] in
                self?.showAlert(of: $0, with: $1)
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert(of result: Bool, with title: String) {
        let alertViewController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let successAlertAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.performSegue(withIdentifier: "TabBarVC", sender: nil)
        })
        let failureAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertViewController.addAction(result ? successAlertAction : failureAlertAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
}
