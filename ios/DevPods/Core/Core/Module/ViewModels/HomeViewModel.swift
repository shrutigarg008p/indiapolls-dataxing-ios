import Combine

public class HomeViewModel: LoadableListViewModelBase<SurveysDto> {
    public let firstSurvey = CurrentValueSubject<SurveysDto?, Never>(nil)
    
    @Published public var surveys = [SurveysDto]()
    @Published public var dashboardMessage: DashboardMessageUiState?
    @Published public var timeForFirstSurvey: String?

    private let profilePendingMessageColorCode = "#FF0000"
    private var profile: LoadableViewModelBase<ServerResponseDto<ProfileDetailsDto>>!
    
    public override func initialize(with data: NavigationData?) {
        let userId = (environment.appState?.auth?.basicProfile?.userID).orEmpty
        
        profile = LoadableViewModelBase()
        profile.initialize { [unowned self] in
            try await self.api.getLoggedInUserProfile(requestId: userId)
        }
        
        profile.resultWasFound = { [weak self] result in
            guard let self = self, let data = result.data?.dashboardMessage else { return }
            let uiState = DashboardMessageUiState(message: data.messages, color: data.colourCode, isProfilePending: data.colourCode == profilePendingMessageColorCode)
            self.dashboardMessage = uiState
        }
        
        super.initialize(work: { [unowned self] in
            try await self.api.getSurveys(requestId: userId)
        })
    }
    
    override func setBindings() {
        super.setBindings()
        
        firstSurvey
            .map(\.?.survey.surveyLength?.asMin)
            .sink { [weak self] value in
                self?.timeForFirstSurvey = value
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest(profile.isExecuting, isExecuting)
            .map { $0 || $1 }
            .subscribe(isBusy)
            .store(in: &cancellables)
    }
    
    public override func execute() {
        super.execute()
        
        profile.execute()
    }
    
    override func resultWasFound(result: ServerResponseDto<[SurveysDto]>) {
        super.resultWasFound(result: result)
        
        surveys = result.data ?? []
        
        if let first = result.data?.first {
            firstSurvey.send(first)
        }
    }
    
    public func dashboardMessageWasTapped() {
        let isProfilePending = dashboardMessage?.isProfilePending ?? false
        if(isProfilePending) {
            navigate(to: .profiles)
        } else {
            navigate(to: .rewards)
        }
    }
    
    public func navigateToFirstSurvey() {
        if let survey = firstSurvey.value {
            openUrlInExternalWeb(url: survey.temporarySurveyLink)
        }
    }
    
    public func updateToken(token: String?) {
        environment.pushNoticationTokenService.update(token: token)
    }
}
