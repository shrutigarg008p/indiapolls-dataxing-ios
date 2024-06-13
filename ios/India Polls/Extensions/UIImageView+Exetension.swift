import UIKit
import Kingfisher

extension UIImageView {
    func load(url: URL?) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url,
                         options: [.transition(.fade(0.5))])
    }
    
    func loadProfileImage(url: URL?) {
        self.kf.setImage(with: url,
                         placeholder: UIImage(named: "ic_profile_placeholder"),
                         options: [.transition(.fade(0.5))])
    }
}
