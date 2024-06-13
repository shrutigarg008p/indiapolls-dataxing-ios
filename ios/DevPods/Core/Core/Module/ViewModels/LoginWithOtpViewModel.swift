import Combine

public class LoginWithOtpViewModel: LoadableViewModelBase<ServerResponseDto<LoginWithOtpResponseDto>> {
    @Published public var phoneNumber: String = .empty
    @Published public var phoneNumberError: String? = nil

    public override func initialize(with data: NavigationData?) {
#if DEBUG
        phoneNumber = "8742980504"
#endif
        
        super.initialize(work: { [unowned self] in
            try await self.api.loginWithOtp(requestDto: self.createLoginRequest())
        })
    }
    
    override func resultWasFound(result: ServerResponseDto<LoginWithOtpResponseDto>?) {
        guard let auth = result?.data else { return }
        
        save(AuthDto(id: auth.userId,
                                email: auth.email,
                                phoneNumber: auth.phoneNumber,
                                registerType: "mobile",
                                role: "",
                                emailConfirmed: true,
                                phoneNumberConfirmed: true,
                                token: auth.token,
                                language: nil,
                                basicProfile: nil))
        navigate(to: .otpVerification, data: [.completionNavigation : CompletionNavigation.home, .loginWithOtp : true])
    }
    
    override func isValidRequest() -> Bool {
        let phoneNumberError = phoneNumber.isPhoneNumberValid ? nil : Strings.invalidMobileNumber
        self.phoneNumberError = phoneNumberError
        return phoneNumberError.isEmpty
    }
    
    public func loginWasTapped() {
        execute()
    }
    
    private func createLoginRequest() -> LoginWithOtpRequestDto {
        let request = LoginWithOtpRequestDto(email: "\(phoneNumber)@gmail.com",
                                             phoneNumber: phoneNumber,
                                             registerType: "mobile")
        
        return request
    }
}
