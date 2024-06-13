import Combine

public class RedeemPointsViewModel: LoadableViewModelBase<BaseServerResponseDto> {
    @Published public var points: String = ""
    @Published public var mode: String = ""
    @Published public var description: String = ""
    
    @Published public var pointsError: String? = nil
    @Published public var modeError: String? = nil
    
    @Published public var modes: [RedemptionDto] = []
    
    private var getModes: LoadableListViewModelBase<RedemptionDto>!
    private var selectedMode: RedemptionDto!
    
    public override func initialize(with data: NavigationData?) {
        let userId = (environment.appState?.auth?.id).orEmpty
        
        getModes = LoadableListViewModelBase()
        
        getModes.initialize { [unowned self] in
            try await self.api.getAllRedemption()
        }
        
        getModes.resultWasFound = { [weak self] res in
            guard let self, let items = res.data else {
                return
            }
            
            self.modes = items
        }
        
        super.initialize { [unowned self] in
            try await self.api.sendRedemptionRequest(request: self.createRequest(userId))
        }
    }
    
    override func resultWasFound(result: BaseServerResponseDto) {
        super.resultWasFound(result: result)
        
        navigateBackWithDialog(result.message)
    }
    
    override func setBindings() {
        super.setBindings()
        
        Publishers.CombineLatest(getModes.isExecuting, isExecuting)
            .map { $0 || $1 }
            .subscribe(isBusy)
            .store(in: &cancellables)
    }
    
    override func isValidRequest() -> Bool {
        pointsError = points.isValid ? nil : Strings.invalidPoints
        modeError = selectedMode.hasValue ? nil : Strings.invalidMode
        return pointsError.isEmpty && modeError.isEmpty
    }
    
    public func getModesFromServer() {
        getModes.execute()
    }
    
    public func redemptionModeWasChanged(_ index: Int) {
        if modes.indices.contains(index) {
            selectedMode = modes[index]
        }
    }
    
    public func submitWasTapped() {
        execute()
    }
    
    private func createRequest(_ userId: String) -> RedemptionRequestDto {
        let points = points.toInt
        
        return RedemptionRequestDto(pointsRequested: points, redemptionModeTitle: selectedMode.name, redemptionModeId: selectedMode.id, userId: userId, redemptionRequestStatus: "New", notes: description, pointsRedeemed: 0)
    }
}
