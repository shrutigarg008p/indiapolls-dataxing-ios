import MaterialComponents
import Core
import SwiftUI

struct MDCOutlinedTextFieldWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var error: String?
    var placeholder: String
    var label: String
    var kb: UIKeyboardType = .default
    var secure: Bool = false
    
    func makeUIView(context: Context) -> MDCOutlinedTextField {
        let textField = MDCOutlinedTextField()
        if secure {
            textField.setPasswordStyle(placeholder: placeholder, label: label)
        } else {
            textField.setDefaultStyle(placeholder: placeholder, label: label)
        }
        textField.delegate = context.coordinator
        textField.keyboardType = kb
        return textField
    }
    
    func updateUIView(_ uiView: MDCOutlinedTextField, context: Context) {
        uiView.text = text
        uiView.error(error)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, error: $error)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var error: String?
        
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
