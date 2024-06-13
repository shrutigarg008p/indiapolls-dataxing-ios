import Combine

public class RewardsViewModel: LoadableViewModelBase<ServerResponseDto<RewardsDto>> {
    @Published public var items = [RewardItemView]()
    
    public override func initialize(with data: NavigationData?) {
        let userId = (environment.appState?.auth?.id).orEmpty
        super.initialize(work: { [unowned self] in
            try await self.api.getRewards(requestId: userId)
        })
    }
    
    override func resultWasFound(result: ServerResponseDto<RewardsDto>) {
        if let data = result.data {
            let items = data.data.map { RewardItemView(name: ($0.survey?.name ?? $0.rewardType), points: ($0.survey?.ceggPoints ?? $0.points))
            } + data.totalPointsInfo.map { RewardItemView(name: $0.name, points: $0.value)
            }
            
            self.items = items
        }
    }
    
    public func redeemWasTapped() {
        navigate(to: .redeemPoints)
    }
}
