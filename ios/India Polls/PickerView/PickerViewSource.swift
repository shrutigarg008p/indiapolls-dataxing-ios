import UIKit

struct PickerItem {
    let index: Int
    let title: String
}

class PickerViewSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    private let pickerView: UIPickerView
    private let onItemClick : ((PickerItem) -> Void)
    
    private var items: [String] = []

    var selectedItem: PickerItem?

    init(pickerView: UIPickerView, onItemClick: @escaping ((PickerItem) -> Void)) {
        self.pickerView = pickerView
        self.onItemClick = onItemClick
        super.init()

        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
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
        guard !items.isEmpty else {
            return
        }
        
        let pickerItem = PickerItem(index: row, title: items[row])
        selectedItem = pickerItem
        onItemClick(pickerItem)
    }
    
    func update(items: [String]) {
        self.items = items
        self.pickerView.reloadAllComponents()
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}
