import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class HomeViewController: UIViewController {
    @IBOutlet private weak var carAppendView: UIView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        carAppendView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                self?.performSegue(withIdentifier: "HomeDetailViewController", sender: nil)
            })
            .disposed(by: disposeBag)
    }
}
