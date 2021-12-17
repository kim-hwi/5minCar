import UIKit
import RxSwift
import RxGesture

extension UIViewController {
    func bindKeyboard(at disposeBag: DisposeBag) {
        view.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorRecover: { _ in .never()})
            .drive(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}
