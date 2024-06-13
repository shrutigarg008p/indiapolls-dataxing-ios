import UIKit
import Core

class MenuCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MenuCollectionViewCell"
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            menuTitleLabel.font = UIFont(name: isSelected ? Fonts.Medium : Fonts.Regular, size: FontSize.size16)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUi()
    }
    
    private func setUi() {
        menuTitleLabel.setPrimaryRegular16LabelStyle(text: .empty)
        menuImageView.image = nil
    }
    
    func set(data: MenuItem) {
        menuImageView.image = UIImage(named: data.icon)
        menuTitleLabel.text = data.title
    }
}
