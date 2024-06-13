import UIKit

class NavigationBarView: UIView {
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var onLeftButtonClick: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        rootView = Bundle.main.loadNibNamed("NavigationBarView", owner: self, options: nil)?.first as! UIView
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(rootView)
        
        leftButton.addTarget(self, action: #selector(leftButtonWasTapped), for: .touchUpInside)
    }
    
    @objc private func leftButtonWasTapped() {
        onLeftButtonClick?()
    }
}
