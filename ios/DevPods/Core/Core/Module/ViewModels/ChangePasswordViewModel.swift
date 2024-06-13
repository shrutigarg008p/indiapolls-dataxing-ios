import Combine

public class ChangePasswordViewModel: LoadableViewModelBase<BaseServerResponseDto> {
    @Published public var currentPassword: String = .empty
    @Published public var newPassword: String = .empty
    @Published public var confirmNewPassword: String = .empty
    
    @Published public var currentPasswordError: String? = nil
    @Published public var newPasswordError: String? = nil
    @Published public var confirmNewPasswordError: String? = nil
    
    public override func initialize(with data: NavigationData?) {
        let userId = (environment.appState?.auth?.id).orEmpty
        
        initialize { [unowned self] in
            try await self.api.changePassword(request: self.createRequest(userId))
        }
    }
    
    override func resultWasFound(result: BaseServerResponseDto) {
        navigateBack()
    }
    
    override func isValidRequest() -> Bool {
        currentPasswordError = currentPassword.isValid ? nil : Strings.invalidPassword
        newPasswordError = newPassword.isValid ? nil : Strings.invalidPassword
        confirmNewPasswordError = newPassword.elementsEqual(confirmNewPassword) && confirmNewPassword.hasValue ? nil : Strings.invalidConfirmPassword
        
        return currentPasswordError.isEmpty && newPasswordError.isEmpty && confirmNewPasswordError.isEmpty
    }
    
    public func changePasswordWasTapped() {
        execute()
    }
    
    private func createRequest(_ userId: String) -> ChangePasswordRequestDto {
        ChangePasswordRequestDto(currentPassword: currentPassword, newPassword: newPassword, userId: userId)
    }
}
