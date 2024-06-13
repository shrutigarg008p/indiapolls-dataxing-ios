import UIKit
import Core

class Dialog: DialogProtocol {
    var topViewController: UIViewController? {
        UIApplication.shared.navigationController?.topViewController
    }
    
    func showMessage(title: String, message: String) {
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        
        alertMessagePopUpBox.addAction(okButton)
        DispatchQueue.main.async {
            self.topViewController?.present(alertMessagePopUpBox, animated: true)
        }
    }
    
    func showMessage(title: String, message: String, okAction: (() -> Void)?) {
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            okAction?()
        }
        
        alertMessagePopUpBox.addAction(okButton)
        DispatchQueue.main.async {
            self.topViewController?.present(alertMessagePopUpBox, animated: true)
        }
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}
