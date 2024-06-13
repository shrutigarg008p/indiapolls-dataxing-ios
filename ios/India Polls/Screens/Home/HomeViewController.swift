import UIKit
import FirebaseMessaging
import Core
import SwiftUI

class HomeViewController: BaseViewController<HomeViewModel> {
    private let drawerController: DrawerMenuViewController = ViewControllerFactory.create(from: .drawerMenu)
    private let transitionManager = DrawerTransitionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUi()
        setEventHandlers()
        addLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        viewModel.execute()
        sendTokenToServer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUi() {
        view.setDefaultBackgroundColor()
        
        let hostingController = UIHostingController(rootView: HomeView(viewModel: viewModel))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
        
    }
    
//    self?.openUrlInExternalWeb(url: item.temporarySurveyLink)
    private func setEventHandlers() {
        drawerController.modalPresentationStyle = .custom
        drawerController.transitioningDelegate = transitionManager
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_hamburger_menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuButton))
        
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe))
        swipeGestureRecognizerDown.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizerDown)
    }
    
    @objc private func handleMenuButton() {
        present(drawerController, animated: true)
    }
    
    @objc private func didSwipe() {
        present(drawerController, animated: true)
    }
    
    private func sendTokenToServer() {
        Messaging.messaging().token { [weak self] token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else {
                if let self {
                    self.viewModel.updateToken(token: token)
                }
            }
        }
    }
}
