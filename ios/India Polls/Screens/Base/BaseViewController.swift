import UIKit
import Combine
import Core

class BaseViewController<T: BaseViewModel>: UIViewController {
    var cancellables: Set<AnyCancellable> = .init()
    var viewModel: T!
    var loader : UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerDismissKeyboardOnOutsideTap()
        setBindings()
    }
    
    func navigateBack(animated: Bool = true) {
        viewModel.navigateBack(animated: animated)
    }
    
    func navigate(to page: PageType, animated: Bool = true) {
        viewModel.navigate(to: page)
    }
    
    func openUrlInExternalWeb(url: String) {
        viewModel.openUrlInExternalWeb(url: url)
    }
    
    func registerDismissKeyboardOnOutsideTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setBindings() {
        viewModel.isBusy
            .sink { [weak self] isBusy in
                self?.showLoader(show: isBusy)
            }.store(in: &cancellables)
    }
    
    func addLoader() {
        if loader == nil {
            let ai = UIActivityIndicatorView.init(style: .large)
            ai.tintColor = Colors.AccentColor
            ai.color = Colors.AccentColor
            ai.hidesWhenStopped = true
            ai.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(ai)

            ai.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            ai.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            self.loader = ai
        }
    }
    
    func showLoader(show: Bool) {
        onMainThread {
            if show {
                self.loader?.startAnimating()
            } else {
                self.loader?.stopAnimating()
            }
        }
    }
    
    func onMainThread(_ work: @escaping () -> Void) {
        DispatchQueue.main.async {
            work()
        }
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}
