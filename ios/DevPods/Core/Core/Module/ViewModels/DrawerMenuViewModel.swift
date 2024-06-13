import Combine
import Foundation

public class DrawerMenuViewModel: LoadableViewModelBase<ServerResponseDto<ProfileDetailsDto>> {
    public var items = Array(MenuItem.allCases.dropFirst())
    public let imagePath = CurrentValueSubject<URL?, Never>(nil)
    public let name = CurrentValueSubject<String, Never>(.empty)
    public let email = CurrentValueSubject<String, Never>(.empty)
    
    public override func initialize(with data: NavigationData?) {
        let userId = (environment.appState?.auth?.id).orEmpty
        if let fullName = environment.appState?.auth?.basicProfile?.fullName {
            self.name.send(fullName)
        }
        
        if let email = environment.appState?.auth?.email {
            self.email.send(email)
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
}
