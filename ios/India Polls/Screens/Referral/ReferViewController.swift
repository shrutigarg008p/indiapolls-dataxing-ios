import UIKit
import SwiftUI
import Core

class ReferViewController: BaseViewController<ReferViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultBackgroundColor()
        
        let hostingController = UIHostingController(rootView: ReferView(viewModel: viewModel, onBackPress: { [weak self] in
            self?.viewModel.navigateBack()
        }, onRefer: { [weak self] in
            self?.viewModel.referWasTapped()
        }))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
        
        addLoader()
    }
}
