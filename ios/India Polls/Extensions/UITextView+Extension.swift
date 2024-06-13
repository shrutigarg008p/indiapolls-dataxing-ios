import UIKit
import Core

extension UITextView {
    func setTermsAndCondition() {
        let attributedString = Strings.signingUpTerms.htmlToAttributedString
        
        let range = NSRange(location: 0, length: attributedString.length)
        let replacementAttribute = [.font : UIFont(name: Fonts.Regular, size: FontSize.size14) as Any,
                                    .foregroundColor : Colors.PrimaryTextColor] as [NSAttributedString.Key : Any]
        attributedString.addAttributes(replacementAttribute, range: range)
        
        attributedText = attributedString
    }
}

extension String {
    
    var htmlToAttributedString: NSMutableAttributedString {
        
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)

            return attributedString
        } catch {
            return NSMutableAttributedString()
        }
    }
}
