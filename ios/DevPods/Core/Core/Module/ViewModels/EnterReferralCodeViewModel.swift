import Combine

public class EnterReferralCodeViewModel: LoadableListViewModelBase<ReferDto> {
   
    public override func initialize(with data: NavigationData?) {
        let userId = (environment.appState?.auth?.id).orEmpty
        super.initialize { [unowned self] in
            try await self.api.getReferrals(requestId: userId)
        }
    }
    
    public func submitWasTapped() {
        navigateBack()
    }
}
