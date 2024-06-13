import Combine

public class ReferViewModel: LoadableViewModelBase<ServerResponseDto<ReferDto>> {
    @Published public var name: String = .empty
    @Published public var email: String = .empty
    @Published public var mobile: String = .empty
    
    @Published public var nameError: String? = nil
    @Published public var emailError: String? = nil
    @Published public var mobileError: String? = nil
    
    public override func initialize(with data: NavigationData?) {
        let userId = (environment.appState?.auth?.id).orEmpty
        
        super.initialize { [unowned self] in
            try await self.api.createReferral(request: self.createRequest(userId))
        }
    }
    
    override func resultWasFound(result: ServerResponseDto<ReferDto>) {
        self.navigateBackWithDialog(result.message)
    }
    
    override func isValidRequest() -> Bool {
        nameError = name.isValid ? nil : Strings.invalidName
        emailError = email.isEmailValid ? nil : Strings.invalidEmail
        mobileError = mobile.isPhoneNumberValid ? nil : Strings.invalidMobileNumber
        
        return nameError.isEmpty && emailError.isEmpty && mobileError.isEmpty
    }
    
    public func referWasTapped() {
        execute()
    }
    
    private func createRequest(_ userId: String) -> ReferRequestDto {
        ReferRequestDto(name: name, email: email, userId: userId, referralStatus: "Invited", referralMethod: "Manual", phoneNumber: mobile)
    }
}
