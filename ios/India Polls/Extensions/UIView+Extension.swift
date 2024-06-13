import UIKit

extension UIView {
    func setDefaultBackgroundColor() {
        backgroundColor = Colors.whiteColor
    }
    
    func addTapGesture(_ target: Any?, _ action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    func makeCircular() {
        self.layer.cornerRadius = frame.height / 2
        self.layer.masksToBounds = true;
    }
    
    func setCornerRadius(radius: CGFloat, masksToBounds: Bool = false) {
        layer.cornerRadius = radius
        layer.masksToBounds = masksToBounds
    }
    
    func makeCircularWithBorder(borderWidth: CGFloat = Dimen.dimen1, borderColor: UIColor = Colors.OutlineColor) {
        makeCircular()
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func curveWithBorder(radius: CGFloat = Dimen.dimen6, borderWidth: CGFloat = Dimen.dimen1, borderColor: UIColor = Colors.OutlineColor) {
        setCornerRadius(radius: radius)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func setVisibility(_ show: Bool) {
        isHidden = !show
    }
}
