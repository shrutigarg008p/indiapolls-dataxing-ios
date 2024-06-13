import UIKit
import Core

class EditableViewControllerBase<T: BaseViewModel>: BaseViewController<T> {
    private var skm: ScrollViewKeyboardManager!
    
    var scrollable: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skm = ScrollViewKeyboardManager(view, scrollable)
        skm.registerKeyboardNotification()
    }
}
