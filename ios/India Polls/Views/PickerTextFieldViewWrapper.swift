import SwiftUI
import MaterialComponents

struct PickerTextFieldViewWrapper: UIViewRepresentable {
    @Binding var pickerData: [String]
    @Binding var text: String
    @Binding var error: String?
    var placeholder: String
    var label: String
    var kb: UIKeyboardType = .default
    
    let onPickerItemChange: (PickerItem) -> Void
        
    func makeUIView(context: Context) -> MDCOutlinedTextField {
        let textField = MDCOutlinedTextField()
        textField.setDefaultStyle(placeholder: placeholder, label: label)
        textField.delegate = context.coordinator
        textField.keyboardType = kb
        context.coordinator.pickerTextField = PickerTextField(textField: textField, itemChangeHandler: { item in
            onPickerItemChange(item)
        })
        
        return textField
    }
    
    func updateUIView(_ uiView: MDCOutlinedTextField, context: Context) {
        context.coordinator.pickerTextField?.update(items: pickerData)
        uiView.text = text
        uiView.error(error)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, error: $error)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var error: String?
        
        var pickerTextField: PickerTextField?

        init(text: Binding<String>, error: Binding<String?>) {
            _text = text
            _error = error
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
            error = nil
        }
    }
}
