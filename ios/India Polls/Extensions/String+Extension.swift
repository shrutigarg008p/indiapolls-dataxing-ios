import UIKit

extension Optional where Wrapped == String {
    var toColor: UIColor {
        guard let self else { 
            return Colors.SurveyColor
        }
        
        return UIColor(hex: self)
    }
}
