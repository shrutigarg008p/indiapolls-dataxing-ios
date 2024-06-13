import UIKit
import MaterialComponents
import Core

class DropDownView: UIView {
    @IBOutlet var rootView: UIView!
    @IBOutlet weak var textField: MDCOutlinedTextField!
    private var pickerTextField: PickerTextField!

    var onClick: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        rootView = Bundle.main.loadNibNamed("DropDownView", owner: self, options: nil)?.first as! UIView
        rootView.frame = bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rootView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(rootView)
        
        textField.setDefaultStyle(placeholder: Strings.selectAnOption, label: Strings.selectAnOption)

        pickerTextField = PickerTextField(textField: textField, itemChangeHandler: { [weak self] item in
            guard let self else { return }
            self.onQueryChange(query: item)
        })
    }
    
    func set(options: [OptionItemView]) {
        let selectedIndex = options.firstIndex { $0.isSelected }
        pickerTextField.update(items: options.map { $0.value }, selectedIndex: selectedIndex)
    }
    
    private func onQueryChange(query: PickerItem) {
        onClick?(pickerTextField.selectedPosition)
    }
}
