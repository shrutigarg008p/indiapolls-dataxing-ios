import UIKit

class RadioButtonView: UIView {
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var radioImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        rootView = Bundle.main.loadNibNamed("RadioButtonView", owner: self, options: nil)?.first as! UIView
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(rootView)
        
        titleLabel.setPrimaryMedium16LabelStyle()
        addTapGesture(self, #selector(radioButtonWasTapped))
    }
    
    func set(title: String, checked: Bool) {
        titleLabel.text = title
        updateCheckedStateManually(checked: checked)
    }
    
    @objc private func radioButtonWasTapped() {
        if (!checked) {
            onClick?()
            checked = !checked
            setCheckedState()
        }
    }
    
    func updateCheckedStateManually(checked: Bool) {
        self.checked = checked
        setCheckedState()
    }
    
    func setCheckedState() {
        radioImageView.image = UIImage(named: checked ? "ic_radio_checked" : "ic_radio_unchecked")
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}
