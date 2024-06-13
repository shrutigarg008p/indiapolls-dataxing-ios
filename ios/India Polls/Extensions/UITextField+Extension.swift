import UIKit
import MaterialComponents
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { (($0.object as? UITextField)?.text).orEmpty }
            .eraseToAnyPublisher()
    }
    
    var pickerView: UIPickerView {
        guard let pickerView = inputView as? UIPickerView else {
            let pickerView = UIPickerView()
            self.inputView = pickerView
            return pickerView
        }
        
        return pickerView
    }
    
    func setOTPTextFieldStyle() {
        self.borderStyle = .none
        self.font = UIFont(name: Fonts.Regular, size: FontSize.size24)
        self.textColor = Colors.PrimaryTextColor
        self.keyboardType = .numberPad
        makeCircularWithBorder()
    }
    
    func addToolbar(target: Any, with doneAction: Selector, and cancelAction: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
       
        self.inputAccessoryView = toolBar
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            barButtonItem.tintColor = style == .cancel ? Colors.OutlineColor : Colors.AccentColor
            
            return barButtonItem
        }
    }
}

extension MDCOutlinedTextField {
    func setDefaultStyle(placeholder: String, label: String, isSecure: Bool = false, keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self.label.text = label
        self.font = UIFont(name: Fonts.Regular, size: FontSize.size14)
        self.containerRadius = 3
        self.setTextColor(Colors.PrimaryTextColor, for: .normal)
        self.setTextColor(Colors.PrimaryTextColor, for: .editing)
        self.setFloatingLabelColor(Colors.PrimaryTextColor, for: .normal)
        self.setFloatingLabelColor(Colors.PrimaryTextColor, for: .editing)
        self.setNormalLabelColor(Colors.PrimaryTextColor, for: .normal)
        self.setNormalLabelColor(Colors.PrimaryTextColor, for: .editing)
        self.keyboardType = keyboardType
        self.setOutlineColor(Colors.OutlineColor, for: .normal)
        self.setOutlineColor(Colors.OutlineColor, for: .editing)
        self.textColor = Colors.PrimaryTextColor
        self.isSecureTextEntry = isSecure
        self.setLeadingAssistiveLabelColor(Colors.ErrorColor, for: .normal)
        self.setLeadingAssistiveLabelColor(Colors.ErrorColor, for: .editing)
    }
    
    func setPasswordStyle(placeholder: String, label: String) {
        setDefaultStyle(placeholder: placeholder, label: label, isSecure: true)
        setPasswordTrailingView()
    }
    
    func setTrailingView(image: String) {
        self.trailingView = UIImageView(image: UIImage(named: image))
        self.trailingViewMode = .always
    }
    
    func setPasswordTrailingView() {
        let imageView = UIImageView(image: UIImage(named: "ic_visibility_on"))
        imageView.tag = 101
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 44))
        view.addTapGesture(self, #selector(togglePassword))
        view.addSubview(imageView)
        imageView.center = view.center
        self.trailingView = view
        self.trailingViewMode = .always
    }
    
    @objc private func togglePassword() {
        self.isSecureTextEntry = !self.isSecureTextEntry
        
        if let imageView = trailingView?.viewWithTag(101) as? UIImageView {
            imageView.image = UIImage(named: self.isSecureTextEntry ? "ic_visibility_on" : "ic_visibility_off")
        }
    }
    
    func datePicker<T>(target: T,
                           doneAction: Selector,
                           cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        self.inputView = datePicker
        
        addToolbar(target: target, with: doneAction, and: cancelAction)
    }
    
    func error(_ error: String?) {
        self.leadingAssistiveLabel.text = error
        self.setOutlineColor(error.isEmpty ? Colors.OutlineColor : Colors.ErrorColor, for: .normal)
        self.setOutlineColor(error.isEmpty ? Colors.OutlineColor : Colors.ErrorColor, for: .editing)
        self.setFloatingLabelColor(error.isEmpty ? Colors.PrimaryTextColor : Colors.ErrorColor, for: .normal)
        self.setFloatingLabelColor(error.isEmpty ? Colors.PrimaryTextColor : Colors.ErrorColor, for: .editing)
        self.setNormalLabelColor(error.isEmpty ? Colors.PrimaryTextColor : Colors.ErrorColor, for: .normal)
        self.setNormalLabelColor(error.isEmpty ? Colors.PrimaryTextColor : Colors.ErrorColor, for: .editing)
    }
}

extension MDCOutlinedTextArea {
    func setDefaultStyle(placeholder: String, label: String) {
        self.minimumNumberOfVisibleRows = Dimen.dimen5
        self.maximumNumberOfVisibleRows = Dimen.dimen5
        self.placeholder = placeholder
        self.label.text = label
        self.textView.font = UIFont(name: Fonts.Regular, size: FontSize.size14)
        self.containerRadius = 3
        self.textView.keyboardType = .default
        self.setOutlineColor(Colors.OutlineColor, for: .normal)
        self.setOutlineColor(Colors.OutlineColor, for: .editing)
        self.textView.textColor = Colors.PrimaryTextColor
        self.setTextColor(Colors.PrimaryTextColor, for: .normal)
        self.setTextColor(Colors.PrimaryTextColor, for: .editing)
        self.setFloatingLabel(Colors.PrimaryTextColor, for: .normal)
        self.setFloatingLabel(Colors.PrimaryTextColor, for: .editing)
        self.setNormalLabel(Colors.PrimaryTextColor, for: .normal)
        self.setNormalLabel(Colors.PrimaryTextColor, for: .editing)
    }
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification, object: self.textView)
            .map { (($0.object as? UITextView)?.text).orEmpty }
            .eraseToAnyPublisher()
    }
}
