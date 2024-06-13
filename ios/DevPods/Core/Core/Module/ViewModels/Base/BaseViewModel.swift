import Combine
import Foundation
import Networking

public class BaseViewModel {
    public let isBusy = CurrentValueSubject<Bool, Never>(false)
    let environment = AppEnvironment.current
    let networkMonitor: NetworkMonitor
    let api: ApiService! = AppEnvironment.current.api

    var cancellables: Set<AnyCancellable> = .init()
        
    public required init() {
        networkMonitor = NetworkMonitor()
        networkMonitor.networkStatus.sink { status in
            print("connected to internet status is \(status)")
        }.store(in: &cancellables)
    }
    
    public func initialize() {
        initialize(with: nil)
    }
    
    public func initialize(with data: NavigationData?) {
    }
    
    public func navigateBack(data: NavigationData? = nil, animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            self?.environment.navigationService.goBackOnePage(data: nil, animated: animated)
        }
    }
    
    public func navigate(to page: PageType, data: NavigationData? = nil, animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            self?.environment.navigationService.navigate(to: page, data: data)
        }
    }
    
    public func openUrlInExternalWeb(url: String) {
        DispatchQueue.main.async { [weak self] in
            self?.environment.navigationService.openUrlInExternalWeb(url: url)
        }
    }
    
    public func popToRoot(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            self?.environment.navigationService.popToRootViewController()
        }
    }
    
    public func onMainThread(_ work: @escaping () -> Void) {
        DispatchQueue.main.async {
            work()
        }
    }
    
    public func receive(data: NavigationData? = nil) {
    }
    
    func save(_ auth: AuthDto) {
        environment.appState?.auth = auth
    }
    
    func save(_ profile: ProfileDto) {
        environment.appState?.auth?.basicProfile = profile
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}
