import UIKit
import MaterialComponents

class PickerTextField: NSObject {
    private let textField: UITextField
    private let itemChangeHandler: (PickerItem) -> Void
    private var pickerSource: PickerViewSource!
    private let pickerView: UIPickerView
    private var items: [String] = []
    
    var selectedItem: PickerItem?
    var selectedPosition: Int = 0

    init(textField: UITextField, itemChangeHandler: @escaping (PickerItem) -> Void) {
        self.textField = textField
        self.itemChangeHandler = itemChangeHandler
        self.pickerView = textField.pickerView
        super.init()
        
        configure()
    }
    
    func update(items: [String], selectedIndex: Int? = nil) {
        self.items = items
        if (selectedIndex != nil) {
            let index = selectedIndex ?? 0
            pickerView.selectRow(index, inComponent: 0, animated: false)
            textField.text = items[index]
        }
        pickerView.reloadAllComponents()
    }
    
    private func configure() {
        if let textField = textField as? MDCOutlinedTextField {
            textField.setTrailingView(image: "ic_arrow_down")
        }

        pickerView.dataSource = self
        pickerView.delegate = self
        self.textField.addToolbar(target: self,
                                  with: #selector(doneButtonWasTapped),
                                  and: #selector(cancelButtonWasTapped))
    }
    
    @objc private func doneButtonWasTapped() {
        let item = selectedItem ?? PickerItem(index: 0, title: items[0])
        
        self.textField.text = item.title
        itemChangeHandler(item)
        
        self.textField.resignFirstResponder()
    }
    
    @objc private func cancelButtonWasTapped() {
        self.textField.resignFirstResponder()
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}


extension PickerTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        items[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickerItem = PickerItem(index: row, title: items[row])
        selectedItem = pickerItem
        selectedPosition = row
    }
}
