import UIKit

class TextView: UIView {
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var termsLabel: UITextView!
    @IBOutlet weak var termsErrorLabel: UILabel!
    
    var onCheckboxClick: (() -> Void)?
    
    private var checked = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        rootView = Bundle.main.loadNibNamed("TextView", owner: self, options: nil)?.first as! UIView
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(rootView)
        termsErrorLabel.setVisibility(false)
        termsLabel.setTermsAndCondition()
        
        checkBoxView.addTapGesture(self, #selector(checkBoxViewWasTapped))
    }
    
    @objc private func checkBoxViewWasTapped() {
        checked = !checked
        checkImageView.image = UIImage(named: checked ? "ic_checkbox_checked" : "ic_checkbox_unchecked")
        onCheckboxClick?()
    }
}
