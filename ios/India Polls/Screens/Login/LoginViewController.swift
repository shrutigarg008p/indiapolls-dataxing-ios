import UIKit
import MaterialComponents
import FacebookLogin
import FacebookCore
import FirebaseAuth
import Core

class LoginViewController: EditableViewControllerBase<LoginViewModel> {
    @IBOutlet weak var navigationBarView: NavigationBarView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var emailTextField: MDCOutlinedTextField!
    @IBOutlet weak var passwordTextField: MDCOutlinedTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var fbConnectButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var orLabel1: UILabel!
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var orLabel2: UILabel!
    
    private var auth: Auth!
    
    override func viewDidLoad() {
        scrollable = scrollView
        
        super.viewDidLoad()
        
        addLoader()
        setUi()
        setEventHandlers()
        setBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUi() {
        navigationBarView.leftButton.isHidden = true
        headingLabel.setPrimaryMedium24LabelStyle(text: Strings.signInToGetInTouch)
        emailTextField.setDefaultStyle(placeholder: Strings.emailPlaceholder, label: Strings.emailPlaceholder, keyboardType: .emailAddress)
        passwordTextField.setPasswordStyle(placeholder: Strings.passwordPlaceholder, label: Strings.passwordPlaceholder)
        
        forgotPasswordButton.setInlineStyle(text: Strings.forgotPassword)
        loginButton.setDefaultStyle(text: Strings.login)
        otpButton.setDefaultStyle(text: Strings.loginWithOtp)
        orLabel1.setPrimaryMedium16LabelStyle(text: Strings.orInCaps)
        orLabel2.setPrimaryMedium16LabelStyle(text: Strings.orInCaps)
        fbConnectButton.setFBStyle(text: Strings.connectWithFacebook)
        signUpLabel.setAttributedSignUp(text1: Strings.dontHaveAnAccount, text2: Strings.signUp)
    }
    
    private func setEventHandlers() {
        loginButton.addTapGesture(self, #selector(loginButtonWasTapped))
        otpButton.addTapGesture(self, #selector(otpButtonWasTapped))
        fbConnectButton.addTapGesture(self, #selector(fbConnectButtonWasTapped))
        forgotPasswordButton.addTapGesture(self, #selector(forgotPasswordButtonWasTapped))
        signUpLabel.addTapGesture(self, #selector(signUpWasTapped))
    }
    
    private func setBindings() {
        emailTextField
            .textPublisher
            .subscribe(viewModel.email)
            .store(in: &cancellables)
        
        viewModel.emailError
            .sink(receiveValue: emailTextField.error)
            .store(in: &cancellables)
        
        viewModel.passwordError
            .sink(receiveValue: passwordTextField.error)
            .store(in: &cancellables)
        
        passwordTextField
            .textPublisher
            .subscribe(viewModel.password)
            .store(in: &cancellables)
    }
    
    @objc private func loginButtonWasTapped() {
        viewModel.loginWasTapped()
    }
    
    @objc private func otpButtonWasTapped() {
        viewModel.navigate(to: .loginWithOtp)
    }
    
    @objc private func forgotPasswordButtonWasTapped() {
        viewModel.forgotPasswordWasTapped();
    }
    
    @objc private func signUpWasTapped() {
        viewModel.signUpWasTapped()
    }
    
    @objc private func fbConnectButtonWasTapped() {
        auth = Auth.auth()
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { [weak self] result, error in
            if let error = error {
                print("Encountered Erorr: \(error)")
            } else if let result = result, result.isCancelled {
                print("Cancelled")
            } else {
                print("Logged In")
                if let accessToken = result?.token {
                    self?.handleFacebookAccessToken(accessToken: accessToken)
                }
            }
        }
    }
    
    private func handleFacebookAccessToken(accessToken: AccessToken) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        auth.signIn(with: credential) { [weak self] result, error in
            if let error = error {
                print("Encountered Erorr: \(error)")
            } else if let result = result {
                print(result.user)
                let authUser = result.user
                let user = FacebookUser(udid: authUser.uid,
                                        email: authUser.email,
                                        name: authUser.displayName,
                                        phoneNumber: authUser.phoneNumber)
                self?.viewModel.facebookLoginWasTapped(user: user)
            }
        }
    }
}
