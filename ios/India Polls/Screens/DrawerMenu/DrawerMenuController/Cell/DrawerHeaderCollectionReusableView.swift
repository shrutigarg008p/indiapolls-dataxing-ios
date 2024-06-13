import UIKit

class DrawerHeaderCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier = "DrawerHeaderCollectionReusableView"
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    func set(url: URL?, name: String, email: String) {
        profileImageView.makeCircular()
        nameLabel.setWhiteMedium16LabelStyle(text: name)
        emailLabel.setWhiteRegular14LabelStyle(text: email)
        
        profileImageView.loadProfileImage(url: url)
    }
}
