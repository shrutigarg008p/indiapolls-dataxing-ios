import UIKit
import Core
import SwiftUI

class RedeemPointsViewController: BaseViewController<RedeemPointsViewModel> {
    private var pickerTextField: PickerTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultBackgroundColor()
        
        let hostingController = UIHostingController(rootView: RedeemPointsView(viewModel: viewModel))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
        
        addLoader()
        
        viewModel.getModesFromServer()
    }
}
