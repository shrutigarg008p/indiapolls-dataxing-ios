import UIKit
import SwiftUI
import Core

class RegisterViewController: BaseViewController<RegisterViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultBackgroundColor()
        
        let hostingController = UIHostingController(rootView: RegisterView(viewModel: viewModel, onBackPress: { [weak self] in
            self?.viewModel.navigateBack()
        }, onNext: { [weak self] in
            self?.viewModel.signUpWasTapped()
        }))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
        
        addLoader()
    }
}
