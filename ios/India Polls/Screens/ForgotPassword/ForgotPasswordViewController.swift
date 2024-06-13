import UIKit
import SwiftUI
import Core

class ForgotPasswordViewController: BaseViewController<ForgotPasswordViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultBackgroundColor()

        let hostingController = UIHostingController(rootView: ForgotPasswordView(viewModel: viewModel, onBackPress: { [weak self] in
            self?.viewModel.navigateBack()
        }, onSubmit: { [weak self] in
            self?.viewModel.submitWasTapped()
        }))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
        
        addLoader()
    }
}
