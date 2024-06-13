import UIKit
import Core

class OTPVerificationViewController: EditableViewControllerBase<OTPVerificationViewModel> {
    private let maxLength = 1
    
    @IBOutlet weak var navigationBarView: NavigationBarView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var verifyOtpLabel: UILabel!
    @IBOutlet weak var otpTextField1: UITextField!
    @IBOutlet weak var otpTextField2: UITextField!
    @IBOutlet weak var otpTextField3: UITextField!
    @IBOutlet weak var otpTextField4: UITextField!
    @IBOutlet weak var resendCodeLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var verifyOtpButton: UIButton!
    
    override func viewDidLoad() {
        scrollable = scrollView

        super.viewDidLoad()

        addLoader()
        setUi()
        setEventHandlers()
        setBindings()
        
        viewModel.generateOTP()
    }
    
    private func setUi() {
        view.setDefaultBackgroundColor()
        registerLabel.setPrimaryMedium24LabelStyle(text: Strings.verifyOtp)
        verifyOtpLabel.setPrimaryRegular14LabelStyle(text: Strings.otpVerificationText)
        resendCodeLabel.setPrimaryMedium16LabelStyle(text: Strings.resendCode)
        verifyOtpButton.setDefaultStyle(text: Strings.verifyOtp)
        otpTextField1.setOTPTextFieldStyle()
        otpTextField2.setOTPTextFieldStyle()
        otpTextField3.setOTPTextFieldStyle()
        otpTextField4.setOTPTextFieldStyle()
        
        otpTextField1.becomeFirstResponder()
    }
    
    private func setEventHandlers() {
        otpTextField1.delegate = self
        otpTextField2.delegate = self
        otpTextField3.delegate = self
        otpTextField4.delegate = self

        navigationBarView.onLeftButtonClick = { [weak self] in
            guard let self else {
                return
            }
            
            self.navigateBack()
        }
        
        resendCodeLabel.addTapGesture(self, #selector(resendCodeWasTapped))
        verifyOtpButton.addTapGesture(self, #selector(verifyOtpButtonWasTapped))
    }
    
    private func setBindings() {
        viewModel.otpError
            .sink(receiveValue: errorLabel.error)
            .store(in: &cancellables)
    }
    
    @objc private func resendCodeWasTapped() {
        viewModel.resendOTPWasTapped()
    }
    
    @objc private func verifyOtpButtonWasTapped() {
        viewModel.otpText1.send(otpTextField1.text.orEmpty)
        viewModel.otpText2.send(otpTextField2.text.orEmpty)
        viewModel.otpText3.send(otpTextField3.text.orEmpty)
        viewModel.otpText4.send(otpTextField4.text.orEmpty)
        viewModel.verifyOTPWasTapped()
    }
}

extension OTPVerificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == maxLength {
            textField.text = string
            focusNext(textField)
            return false
        }
        
        return true
    }
    
    private func focusNext(_ textField: UITextField) {
        if textField == otpTextField1 {
            otpTextField2.becomeFirstResponder()
        } else if textField == otpTextField2 {
            otpTextField3.becomeFirstResponder()
        } else if textField == otpTextField3 {
            otpTextField4.becomeFirstResponder()
        } else if textField == otpTextField4 {
            textField.resignFirstResponder()
        }
    }
}
