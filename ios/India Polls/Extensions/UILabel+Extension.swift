import UIKit

public extension UILabel {
    func setPrimaryMedium16LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.PrimaryTextColor, font: Fonts.Medium, size: FontSize.size16, text: text)
    }
    
    func setPrimaryMedium14LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.PrimaryTextColor, font: Fonts.Medium, size: FontSize.size14, text: text)
    }
    
    func setWhiteMedium18LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.whiteColor, font: Fonts.Medium, size: FontSize.size18, text: text)
    }
    
    func setWhiteMedium16LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.whiteColor, font: Fonts.Medium, size: FontSize.size16, text: text)
    }
    
    func setWhiteMedium14LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.whiteColor, font: Fonts.Medium, size: FontSize.size14, text: text)
    }
    
    func setWhiteMedium12LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.whiteColor, font: Fonts.Medium, size: FontSize.size12, text: text)
    }
    
    func setWhiteRegular14LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.whiteColor, font: Fonts.Regular, size: FontSize.size14, text: text)
    }
    
    func setWhiteSemiBold14LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.whiteColor, font: Fonts.SemiBold, size: FontSize.size14, text: text)
    }
    
    func setPrimaryMedium18LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.PrimaryTextColor, font: Fonts.Medium, size: FontSize.size18, text: text)
    }
    
    func setPrimaryMedium20LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.PrimaryTextColor, font: Fonts.Medium, size: FontSize.size20, text: text)
    }
    
    func setPrimaryMedium24LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.PrimaryTextColor, font: Fonts.Medium, size: FontSize.size24, text: text)
    }
    
    func setPrimaryRegular14LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.PrimaryTextColor, font: Fonts.Regular, size: FontSize.size14, text: text)
    }
    
    func setPrimaryRegular12LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.PrimaryTextColor, font: Fonts.Regular, size: FontSize.size12, text: text)
    }
    
    func setPrimaryRegular16LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.PrimaryTextColor, font: Fonts.Regular, size: FontSize.size16, text: text)
    }
    
    func setSecondaryRegular14LabelStyle(text: String? = nil) {
        setLabelStyle(textColor: Colors.SecondaryTextColor, font: Fonts.Regular, size: FontSize.size14, text: text)
    }
    
    func setAttributedSignUp(text1: String, text2: String) {
        let attr1 = [NSAttributedString.Key.font : UIFont(name: Fonts.Regular, size: FontSize.size14) as Any,
                     NSAttributedString.Key.foregroundColor : Colors.PrimaryTextColor.withAlphaComponent(0.6)] as [NSAttributedString.Key : Any]
        let attr2 = [NSAttributedString.Key.font : UIFont(name: Fonts.Medium, size: FontSize.size14) as Any,
                         NSAttributedString.Key.foregroundColor : Colors.PrimaryTextColor] as [NSAttributedString.Key : Any]

        let attributedString1 = NSMutableAttributedString(string: text1, attributes: attr1)
        let attributedString2 = NSMutableAttributedString(string: text2, attributes: attr2)
        attributedString1.append(attributedString2)
        
        attributedText = attributedString1
    }
    
    func makeMultiline() {
        numberOfLines = 0
    }
    
    func error(_ error: String?) {
        setLabelStyle(textColor: Colors.ErrorColor, font: Fonts.Regular, size: FontSize.size12, text: error)
        setVisibility(error.hasValue)
    }
    
    func setLabelStyle(textColor: UIColor, font: String, size: CGFloat, text: String? = nil) {
        self.textColor = textColor
        self.text = text
        self.font = UIFont(name: font, size: size)
    }
}
