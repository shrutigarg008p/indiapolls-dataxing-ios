import UIKit
import SwiftUI
import Core

class CompletionViewController: BaseViewController<BaseViewModel> {
    var onCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: CompletionView(viewModel: viewModel, onCompletion: { [weak self] in
            self?.onCompletion?()
        }))
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        
        hostingController.didMove(toParent: self)
    }
}
