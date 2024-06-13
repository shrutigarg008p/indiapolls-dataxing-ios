import UIKit
import Core
import SwiftUI

class MyDashboardViewController: BaseViewController<MyDashboardViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultBackgroundColor()
        
        let hostingController = UIHostingController(rootView: MyDashboardView(viewModel: viewModel))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
        
        addLoader()
        
        viewModel.execute()
    }
}
