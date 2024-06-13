import UIKit

class CheckBoxView: UIView {
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var checkBoxView1: UIStackView!
    @IBOutlet weak var checkBoxImageView1: UIImageView!
    @IBOutlet weak var checkBoxLabel1: UILabel!

    private(set) var checked = false

    var onClick: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        rootView = Bundle.main.loadNibNamed("CheckBoxView", owner: self, options: nil)?.first as! UIView
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(rootView)
        
        checkBoxLabel1.setPrimaryMedium16LabelStyle()
        addTapGesture(self, #selector(checkBoxWasTapped))
    }

    func set(title: String, checked: Bool) {
        checkBoxLabel1.text = title
        self.checked = checked
        setCheckedState()
    }
    
    @objc private func checkBoxWasTapped() {
        checked = !checked
        setCheckedState()
        onClick?()
    }
    
    func setCheckedState() {
        checkBoxImageView1.image = UIImage(named: checked ? "ic_checkbox_checked" : "ic_checkbox_unchecked")
    }
}
