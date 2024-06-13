import UIKit
import MaterialComponents
import Combine
import Core
import SwiftUI

class ChangePasswordViewController: BaseViewController<ChangePasswordViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultBackgroundColor()
        
        let hostingController = UIHostingController(rootView: ChangePasswordView(viewModel: viewModel, onBackPress: { [weak self] in
            self?.viewModel.navigateBack()
        }, onSubmit: { [weak self] in
            self?.viewModel.changePasswordWasTapped()
        }))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
        
        addLoader()
    }
}
