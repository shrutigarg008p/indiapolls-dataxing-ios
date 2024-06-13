import Combine

public class MyProfilesViewModel: LoadableViewModelBase<ServerResponseDto<ProfilesDto>> {
    @Published public var items = [SurveyProfileDto]()
    
    public override func initialize(with data: NavigationData?) {
        let userId = (environment.appState?.auth?.id).orEmpty
        super.initialize { [unowned self] in
            try await self.api.getProfiles(requestId: userId)
        }
    }
    
    override func resultWasFound(result: ServerResponseDto<ProfilesDto>) {
        if let data = result.data {
            items = data.result.sorted(by: { $0.displayOrder < $1.displayOrder })
        }
    }
    
    public func startSurveyWasTapped(_ item: SurveyProfileDto) {
        navigate(to: .startSurvey, data: [.surveyProfileId : item.id])
    }
}
