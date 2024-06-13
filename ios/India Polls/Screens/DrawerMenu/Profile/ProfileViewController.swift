import UIKit
import Core

class ProfileViewController: BaseViewController<ProfileViewModel> {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var verifyMobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var changePasswordLabel: UILabel!
    @IBOutlet weak var unsubscribeLabel: UILabel!
    @IBOutlet weak var deleteAccountLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var deleteAccountView: UIStackView!
    @IBOutlet weak var unsubscribeEmailView: UIStackView!
    @IBOutlet weak var changePasswordView: UIStackView!
    @IBOutlet weak var verifyMobileView: UIStackView!
    
    private var imagePickerManager: ImagePickerManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerManager = ImagePickerManager()
        addLoader()
        setUi()
        setEventHandlers()
        setBindings()
        
        viewModel.execute()
    }
    
    private func setUi() {
        view.setDefaultBackgroundColor()
        titleLabel.setPrimaryMedium24LabelStyle(text: Strings.myProfile)
        profileImageView.makeCircular()
        profileNameLabel.setPrimaryMedium24LabelStyle()
        emailLabel.setPrimaryMedium14LabelStyle()
        verifyMobileLabel.setPrimaryMedium16LabelStyle(text: Strings.verifyMobile)
        changePasswordLabel.setPrimaryMedium16LabelStyle(text: Strings.changePassword)
        unsubscribeLabel.setPrimaryMedium16LabelStyle(text: Strings.unsubscribeEmail)
        deleteAccountLabel.setPrimaryMedium16LabelStyle(text: Strings.deleteAccount)
        deleteAccountLabel.textColor = Colors.ErrorColor
        logoutButton.setDefaultStyle(text: Strings.logout)
    }
    
    private func setEventHandlers() {
        backButton.addTapGesture(self, #selector(backButtonWasTapped))
        deleteAccountView.addTapGesture(self, #selector(deleteAccountWasTapped))
        unsubscribeEmailView.addTapGesture(self, #selector(unsubscribeEmailViewWasTapped))
        changePasswordView.addTapGesture(self, #selector(changePasswordViewWasTapped))
        verifyMobileView.addTapGesture(self, #selector(verifyMobileViewWasTapped))
        logoutButton.addTapGesture(self, #selector(logoutButtonWasTapped))
        profileImageView.addTapGesture(self, #selector(profileImageViewWasTapped))
    }
    
    private func setBindings() {
        viewModel.name
            .sink { [weak self] value in
                self?.profileNameLabel.text = value
            }
            .store(in: &cancellables)
        
        viewModel.email
            .sink { [weak self] value in
                self?.emailLabel.text = value
            }
            .store(in: &cancellables)
        
        viewModel.imagePath
            .sink { [weak self] url in
                self?.profileImageView.loadProfileImage(url: url)
            }
            .store(in: &cancellables)
    }
    
    @objc private func backButtonWasTapped() {
        navigateBack()
    }
    
    @objc private func unsubscribeEmailViewWasTapped() {
        viewModel.unsubscribeEmailWasTapped()
    }
    
    @objc private func changePasswordViewWasTapped() {
        viewModel.changePasswordWasTapped()
    }
    
    @objc private func verifyMobileViewWasTapped() {
        viewModel.verifyMobileWasTapped()
    }
    
    @objc private func deleteAccountWasTapped() {
        viewModel.deleteAccountWasTapped()
    }
    
    @objc private func logoutButtonWasTapped() {
        viewModel.logoutWasTapped()
    }
    
    @objc private func profileImageViewWasTapped() {
        imagePickerManager.showActionSheet(vc: self) { [weak self] image in
            self?.profileImageView.image = image
            self?.viewModel.imageWasChanged(with: image.jpegData(compressionQuality: 0.3))
        }
    }
}
