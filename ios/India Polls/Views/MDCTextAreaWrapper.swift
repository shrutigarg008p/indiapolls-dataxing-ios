import MaterialComponents
import Core
import SwiftUI

struct MDCTextAreaWrapper: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var label: String
    
    func makeUIView(context: Context) -> MDCOutlinedTextArea {
        let textField = MDCOutlinedTextArea()
        textField.setDefaultStyle(placeholder: placeholder, label: label)
        textField.textView.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: MDCOutlinedTextArea, context: Context) {
        uiView.textView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            text = textView.text ?? ""
        }
    }
}
