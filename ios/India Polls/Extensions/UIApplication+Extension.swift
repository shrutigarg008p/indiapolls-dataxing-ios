import UIKit

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.windows
            .first(where: \.isKeyWindow)
    }
    
    var rootViewController: UIViewController? {
        UIApplication.shared.firstKeyWindow?.rootViewController
    }
    
    var navigationController: UINavigationController? {
        rootViewController as? UINavigationController
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
}

extension UIWindow {
    func switchRootViewController(_ viewController: UIViewController,
                                  animated: Bool = true,
                                  duration: TimeInterval = 0.5,
                                  options: AnimationOptions = .transitionFlipFromRight,
                                  completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            makeKeyAndVisible()
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            self.makeKeyAndVisible()
            UIView.setAnimationsEnabled(oldState)
        }, completion: { _ in
            completion?()
        })
    }
}

extension UIViewController {
    static func viewController<T: UIViewController>(from storyboard: String) -> T {
        UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(identifier: String(describing: T.self))
    }
}
