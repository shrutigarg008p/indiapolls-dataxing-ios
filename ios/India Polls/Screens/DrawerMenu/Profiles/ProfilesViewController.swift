import UIKit
import Core
import SwiftUI

class ProfilesViewController: BaseViewController<MyProfilesViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setDefaultBackgroundColor()
        
        let hostingController = UIHostingController(rootView: ProfilesView(viewModel: viewModel))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
        
        addLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.execute()
    }
    
    private func startSurveyWasTapped(_ item: SurveyProfileDto) {
        viewModel.startSurveyWasTapped(item)
    }
}
