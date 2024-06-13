import Combine
import Foundation

public class LoginViewModel: LoadableViewModelBase<ServerResponseDto<AuthDto>> {
    public let email = CurrentValueSubject<String, Never>(.empty)
    public let password = CurrentValueSubject<String, Never>(.empty)
    public let emailError = CurrentValueSubject<String?, Never>(nil)
    public let passwordError = CurrentValueSubject<String?, Never>(nil)
    
    private var loginWithFacebook: LoadableViewModelBase<ServerResponseDto<AuthDto>>!
    
    private var user: FacebookUser!
    
    public override func initialize(with data: NavigationData?) {
#if DEBUG
        email.send("kumar@indiapolls.com")
        password.send("123456789")
//        email.send("softpk@gmail.com")
//        password.send("123456789")
#endif
        loginWithFacebook = LoadableViewModelBase()
        
        loginWithFacebook.initialize { [unowned self] in
            try await self.api.loginWithFacebook(requestDto: self.createFacebookLoginRequest())
        }
        
        loginWithFacebook.resultWasFound = { [weak self] result in
            guard let self, let auth = result.data else {
                return
            }
            
            self.save(auth)
            self.verifyOnBoardingAndProceed()
        }
        
        super.initialize(work: { [unowned self] in
            try await self.api.login(requestDto: self.createLoginRequest())
        })
    }
    
    override func resultWasFound(result: ServerResponseDto<AuthDto>?) {
        guard let auth = result?.data else { return }
        
        save(auth)
        
        if auth.phoneNumberConfirmed {
            verifyOnBoardingAndProceed()
        } else {
            navigate(to: .otpVerification, data: [.completionNavigation : CompletionNavigation.home])
        }
    }
    
    override func isValidRequest() -> Bool {
        let emailError = email.value.isEmailValid ? nil : Strings.invalidEmail
        let passwordError = password.value.isValid ? nil : Strings.invalidPassword
        
        self.emailError.send(emailError)
        self.passwordError.send(passwordError)
        
        return emailError.isEmpty && passwordError.isEmpty
    }
    
    public func loginWasTapped() {
        execute()
    }
    
    public func forgotPasswordWasTapped() {
        navigate(to: .forgotPassword)
    }
    
    public func signUpWasTapped() {
        navigate(to: .register)
    }
    
    public func facebookLoginWasTapped(user: FacebookUser) {
        self.user = user
        
        if user.udid.hasValue {
            loginWithFacebook.execute()
        }
    }
    
    private func verifyOnBoardingAndProceed() {
        let isOnBoardingCompleted = environment.appState.onBoardingCompleted
        if isOnBoardingCompleted {
            navigate(to: .home)
        } else {
            navigate(to: .enterPersonalDetails, data: [.facebookUser : user as Any])
        }
    }
    
    private func createLoginRequest() -> LoginRequestDto {
        let request = LoginRequestDto(email: email.value,
                                      password: password.value,
                                      registerType: "password")
        
        return request
    }
    
    private func createFacebookLoginRequest() -> FacebookLoginRequestDto {
        let request = FacebookLoginRequestDto(email: user.email.orEmpty,
                                              facebooktoken: user.udid,
                                              registerType: "facebook",
                                              role: "panelist")
        return request
    }
}
