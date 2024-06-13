import Combine
import Foundation

public class ProfileViewModel: LoadableViewModelBase<ServerResponseDto<ProfileDetailsDto>> {
    public let name = CurrentValueSubject<String, Never>(.empty)
    public let email = CurrentValueSubject<String, Never>(.empty)
    public let imagePath = CurrentValueSubject<URL?, Never>(nil)

    private var uploadPicture: LoadableViewModelBase<ServerResponseDto<String>>!
    private var unsubscribeEmail: LoadableViewModelBase<BaseServerResponseDto>!
    private var deleteAccount: LoadableViewModelBase<BaseServerResponseDto>!
    private var imageData: Data?
    
    public override func initialize(with data: NavigationData?) {
        if let fullName = environment.appState?.auth?.basicProfile?.fullName {
            self.name.send(fullName)
        }
        
        if let email = environment.appState?.auth?.email {
            self.email.send(email)
        }
        
        let userId = (environment.appState?.auth?.id).orEmpty
        let phoneNumber = (environment.appState?.auth?.phoneNumber).orEmpty

        uploadPicture = LoadableViewModelBase()
        
        uploadPicture.initialize { [unowned self] in
            try await self.api.uploadPicture(request: createRequest(userId))
        }
        
        uploadPicture.resultWasFound = { [weak self] result in
            self?.execute()
        }
        
        unsubscribeEmail = LoadableViewModelBase()
        
        unsubscribeEmail.initialize { [unowned self] in
            try await self.api.unsubscribeEmail(requestId: userId)
        }
        
        unsubscribeEmail.resultWasFound = { [weak self] result in
            print(result.message)
        }
        
        deleteAccount = LoadableViewModelBase()
        
        deleteAccount.initialize { [unowned self] in
            try await self.api.deleteAccount(requestId: userId)
        }
        
        deleteAccount.resultWasFound = { [weak self] result in
            print(result.message)
        }
        
        initialize { [unowned self] in
            try await self.api.getLoggedInUserProfile(requestId: userId)
        }
    }
    
    override func resultWasFound(result: ServerResponseDto<ProfileDetailsDto>) {
        if let profile = result.data?.profile {
            save(profile)
            let path = profile.imagePath
            imagePath.send(path?.toURL())
        }
    }
    
    override func setBindings() {
        super.setBindings()
        
        Publishers.CombineLatest4(unsubscribeEmail.isExecuting, deleteAccount.isExecuting, uploadPicture.isExecuting, isExecuting)
            .map { $0 || $1 || $2 || $3 }
            .subscribe(isBusy)
            .store(in: &cancellables)
    }
    
    public func verifyMobileWasTapped() {
        navigate(to: .otpVerification, data: [.completionNavigation : CompletionNavigation.back])
    }
    
    public func changePasswordWasTapped() {
        navigate(to: .changePassword)
    }
    
    public func unsubscribeEmailWasTapped() {
        unsubscribeEmail.execute()
    }
    
    public func deleteAccountWasTapped() {
        deleteAccount.execute()
    }
    
    public func logoutWasTapped() {
        environment.appState.clear()
        navigate(to: .login)
    }
    
    public func imageWasChanged(with imageData: Data?) {
        self.imageData = imageData
        if imageData.hasValue {
            uploadPicture.execute()
        }
    }
    
    private func createRequest(_ userId: String) -> UploadImageRequestDto {
        let request = UploadImageRequestDto(userId: userId, image: imageData!)
        return request
    }
}
