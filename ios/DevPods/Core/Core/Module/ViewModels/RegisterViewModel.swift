import Combine
import Foundation

public class RegisterViewModel: LoadableViewModelBase<ServerResponseDto<RegisterResponseDto>> {
    @Published public var email: String = .empty
    @Published public var mobile: String = .empty
    @Published public var password: String = .empty
    @Published public var confirmPassword: String = .empty
    @Published public var isTermsAccepted: Bool = false
    
    @Published public var emailError: String? = nil
    @Published public var mobileError: String? = nil
    @Published public var passwordError: String? = nil
    @Published public var confirmPasswordError: String? = nil
    @Published public var termsAcceptedError: String? = nil
    
    public override func initialize(with data: NavigationData?) {
#if DEBUG
        email = "vsfsv+10@y.co"
        mobile = "5637726394"
        password = "qwerty"
        confirmPassword = "qwerty"
#endif
        super.initialize { [unowned self] in
            try await self.api.signUp(requestDto: self.createRegisterRequest())
        }
    }
    
    override func resultWasFound(result: ServerResponseDto<RegisterResponseDto>) {
        guard let data = result.data else  {
            return
        }
        
        save(AuthDto(id: data.userId,
                     email: data.email,
                     phoneNumber: data.phoneNumber,
                     registerType: "mobile",
                     role: "",
                     emailConfirmed: false,
                     phoneNumberConfirmed: false,
                     token: String.empty,
                     language: nil,
                     basicProfile: nil))
        navigate(to: .otpVerification, data: [.completionNavigation : CompletionNavigation.login])
    }
    
    override func isValidRequest() -> Bool {
        emailError = email.isEmailValid ? nil : Strings.invalidEmail
        mobileError = mobile.isPhoneNumberValid ? nil : Strings.invalidMobileNumber
        passwordError = password.isValid ? nil : Strings.invalidPassword
        confirmPasswordError = (password == confirmPassword && !confirmPassword.isEmpty) ? nil : Strings.invalidConfirmPassword
        termsAcceptedError = isTermsAccepted ? nil : Strings.invalidTermsandConditions
        
        return emailError.isEmpty && mobileError.isEmpty && passwordError.isEmpty && confirmPasswordError.isEmpty && termsAcceptedError.isEmpty
    }
    
    public func signUpWasTapped() {
        execute()
    }
    
    public func toggleTerms() {
        isTermsAccepted.toggle()
    }
    
    private func createRegisterRequest() -> RegisterRequestDto {
        RegisterRequestDto(email: email,
                           password: password,
                           phoneNumber: mobile,
                           role: "panelist",
                           registerType: "password")
    }
}
