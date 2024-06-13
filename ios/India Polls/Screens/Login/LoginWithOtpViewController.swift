import UIKit
import MaterialComponents
import Core
import SwiftUI

class LoginWithOtpViewController: BaseViewController<LoginWithOtpViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setDefaultBackgroundColor()

        let hostingController = UIHostingController(rootView: LoginWithOtpView(viewModel: viewModel, onBackPress: { [weak self] in
            self?.viewModel.navigateBack()
        }, onLogin: { [weak self] in
            self?.viewModel.loginWasTapped()
        }))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
        
        addLoader()
    }
}
