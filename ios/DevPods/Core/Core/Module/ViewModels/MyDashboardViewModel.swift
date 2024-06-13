import Combine

public class MyDashboardViewModel: LoadableListViewModelBase<DashboardDto> {
   @Published public var elements = [DashboardDto]()
    
    public override func initialize(with data: NavigationData?) {
        let userId = (environment.appState?.auth?.id).orEmpty
        super.initialize { [unowned self] in
            try await self.api.getDashboard(requestId: userId)
        }
    }
    
    override func resultWasFound(result: ServerResponseDto<[DashboardDto]>) {
        elements = result.data ?? []
    }
}
