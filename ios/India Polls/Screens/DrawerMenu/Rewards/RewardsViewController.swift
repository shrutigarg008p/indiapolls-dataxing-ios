import UIKit
import Core
import SwiftUI

class RewardsViewController: BaseViewController<RewardsViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultBackgroundColor()
        
        let hostingController = UIHostingController(rootView: RewardsView(viewModel: viewModel))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
        
        addLoader()
        
        viewModel.execute()
    }
}
