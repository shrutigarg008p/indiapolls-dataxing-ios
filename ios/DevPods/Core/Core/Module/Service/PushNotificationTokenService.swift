public class PushNotificationTokenService: LoadableViewModelBase<BaseServerResponseDto> {
    private var token: String?
    
    public override func initialize(with data: NavigationData?) {
        super.initialize { [unowned self] in
            try await self.api.updateDeviceToken(requestDto: self.createRequest())
        }
    }
    
    override func resultWasFound(result: BaseServerResponseDto) {
        super.resultWasFound(result: result)
    }
    
    public func update(token: String?) {
        if let isLoggedIn = environment.appState?.isLoggedIn, isLoggedIn, let token = token {
            self.token = token
            execute()
        }
    }
    
    private func createRequest() -> DeviceTokenRequestDto {
        let userId = (environment.appState?.auth?.id).orEmpty
        let request = DeviceTokenRequestDto(userId: userId, token: token!)
        return request
    }
}
