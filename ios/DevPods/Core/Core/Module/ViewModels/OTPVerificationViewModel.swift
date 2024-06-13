import Combine

public class OTPVerificationViewModel: LoadableViewModelBase<BaseServerResponseDto> {
    public let otpText1 = CurrentValueSubject<String, Never>(.empty)
    public let otpText2 = CurrentValueSubject<String, Never>(.empty)
    public let otpText3 = CurrentValueSubject<String, Never>(.empty)
    public let otpText4 = CurrentValueSubject<String, Never>(.empty)
    
    public let otpError = CurrentValueSubject<String?, Never>(nil)
    
    private var resendOTP: LoadableViewModelBase<BaseServerResponseDto>!
    private var getProfile: LoadableViewModelBase<ServerResponseDto<ProfileDetailsDto>>!
    
    private var otp: String!
    private var completionNavigation: CompletionNavigation?
    private var loginWithOtp = false
    
    public override func initialize(with data: NavigationData?) {
        let userId = (environment.appState?.auth?.id).orEmpty
        let phoneNumber = (environment.appState?.auth?.phoneNumber).orEmpty
        
        completionNavigation = data?[.completionNavigation] as? CompletionNavigation
        loginWithOtp = (data?[.loginWithOtp] as? Bool) ?? false
        
        getProfile = LoadableViewModelBase()
        
        getProfile.initialize { [unowned self] in
            try await self.api.getLoggedInUserProfile(requestId: userId)
        }
        
        getProfile.resultWasFound = { [weak self] result in
            guard let self else {
                return
            }
            
            let isOnBoardingCompleted = result.data?.profile.hasValue ?? false
            if isOnBoardingCompleted {
                if let profile = result.data?.profile {
                    save(profile)
                }
                navigate(to: .home)
            } else {
                navigate(to: .enterPersonalDetails)
            }
        }
        
        resendOTP = LoadableViewModelBase()
        
        resendOTP.initialize { [unowned self] in
            try await self.api.resendOTP(request: createResendOTPRequest(userId, phoneNumber))
        }
        
        initialize { [unowned self] in
            try await self.api.verifyOTP(request: createVerifyOTPRequest(userId))
        }
    }
    
    override func resultWasFound(result: BaseServerResponseDto) {
        super.resultWasFound(result: result)
        
        if let completionNavigation {
            switch completionNavigation {
            case .home:
                getProfile.execute()
            case .login:
                navigate(to: .login)
            case .back:
                navigateBack()
            }
        }
    }
    
    override func setBindings() {
        super.setBindings()
        
        Publishers.CombineLatest3(resendOTP.isExecuting, getProfile.isExecuting, isExecuting)
            .map { $0 || $1 || $2 }
            .subscribe(isBusy)
            .store(in: &cancellables)
    }
    
    override func isValidRequest() -> Bool {
        let otpError = otp.isValid ? nil : Strings.invalidOtp
        self.otpError.send(otpError)
        return otpError.isEmpty
    }
    
    public func verifyOTPWasTapped() {
        guard otpText1.value.hasValue,
              otpText2.value.hasValue,
              otpText3.value.hasValue,
              otpText4.value.hasValue else {
            otpError.send(Strings.invalidOtp)
            return
        }
        
        otp = otpText1.value + otpText2.value + otpText3.value + otpText4.value
        execute()
    }
    
    public func generateOTP() {
        if !loginWithOtp {
            resendOTP.execute()
        }
    }
    
    public func resendOTPWasTapped() {
        resendOTP.execute()
    }
    
    private func createVerifyOTPRequest(_ userId: String) -> VerifyOTPRequestDto {
        let request = VerifyOTPRequestDto(userId: userId, otp: otp)
        return request
    }
    
    private func createResendOTPRequest(_ userId: String, _ phoneNumber: String) -> ResendOTPRequestDto {
        let request = ResendOTPRequestDto(userId: userId, phoneNumber: phoneNumber)
        return request
    }
}
