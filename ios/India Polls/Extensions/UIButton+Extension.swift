import UIKit
import SwiftUI

struct DefaultButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(Font.custom(Fonts.Medium, size: FontSize.size14))
            .foregroundColor(Color(Colors.PrimaryButtonTextColor))
            .background(Color(Colors.AccentColor))
            .cornerRadius(Dimen.dimen6)
            .frame(height: 48)
            .padding([.horizontal, .vertical], Dimen.dimen24)
    }
}

struct DefaultButtonStyleWithoutPadding: ButtonStyle {    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(Font.custom(Fonts.Medium, size: FontSize.size14))
            .foregroundColor(Color(Colors.PrimaryButtonTextColor))
            .background(Color(Colors.AccentColor))
            .cornerRadius(Dimen.dimen6)
            .frame(height: 48)
    }
}

public extension UIButton {
    func setDefaultStyle(text: String) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont(name: Fonts.Medium, size: FontSize.size14)
        self.backgroundColor = Colors.AccentColor
        self.layer.cornerRadius = Dimen.dimen6
        self.setTitleColor(Colors.PrimaryButtonTextColor, for: .normal)
    }
    
    func setRegularButtonStyle(text: String) {
        setDefaultStyle(text: text)
        self.titleLabel?.font = UIFont(name: Fonts.Regular, size: FontSize.size14)
    }
    
    func setFBStyle(text: String) {
        setDefaultStyle(text: text)
        self.backgroundColor = Colors.FBColor
    }
    
    func setSecondaryButtonStyle(text: String) {
        setDefaultStyle(text: text)
        self.backgroundColor = Colors.PrimaryInlineButtonTextColor
        self.setTitleColor(Colors.PrimaryButtonTextColor, for: .normal)
    }
    
    func setBorderButtonStyle(text: String) {
        setDefaultStyle(text: text)
        self.backgroundColor = Colors.whiteColor
        self.layer.cornerRadius = Dimen.dimen6
        self.layer.borderColor = Colors.PrimaryInlineButtonTextColor.cgColor
        self.layer.borderWidth = Dimen.dimen1
        self.setTitleColor(Colors.PrimaryTextColor, for: .normal)
        self.titleLabel?.font = UIFont(name: Fonts.Regular, size: FontSize.size14)
    }
    
    func setToggleButtonStyle(_ selected: Bool = false) {
        self.backgroundColor = selected ? Colors.AccentColor : Colors.whiteColor
        self.setTitleColor(selected ? Colors.PrimaryButtonTextColor : Colors.PrimaryTextColor, for: .normal)
        self.layer.borderColor = selected ? Colors.clearColor.cgColor : Colors.PrimaryInlineButtonTextColor.cgColor
        self.layer.borderWidth = selected ? 0 : Dimen.dimen1
    }
    
    func setInlineStyle(text: String) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont(name: Fonts.Medium, size: FontSize.size16)
        self.setTitleColor(Colors.PrimaryInlineButtonTextColor, for: .normal)
    }
    
    func setLightInlineStyle(text: String) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = UIFont(name: Fonts.Regular, size: FontSize.size14)
        self.setTitleColor(Colors.SecondaryTextColor, for: .normal)
    }
}
