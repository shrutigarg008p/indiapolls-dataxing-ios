import Combine

public class ForgotPasswordViewModel: LoadableViewModelBase<BaseServerResponseDto> {
    @Published public var email: String = .empty
    @Published public var emailError: String? = nil
    
    public override func initialize(with data: NavigationData?) {
        super.initialize { [unowned self] in
            try await self.api.sendForgotPasswordLink(request: ForgotPasswordRequestDto(email: email))
        }
    }
    
    override func resultWasFound(result: BaseServerResponseDto) {
        navigateBackWithDialog(result.message)
    }
    
    override func isValidRequest() -> Bool {
        let isValid = email.isEmailValid
        emailError = isValid ? nil : Strings.invalidEmail
        return isValid
    }
    
    public func submitWasTapped() {
        execute()
    }
}
