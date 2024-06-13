public protocol NavigationProtocol {
    func navigate(to page: PageType, data: NavigationData?, animated: Bool)
    func goBackOnePage(data: NavigationData?, animated: Bool)
    func popToRootViewController(animated: Bool)
    func openUrlInExternalWeb(url: String)
}

public extension NavigationProtocol {
    func navigate(to page: PageType, data: NavigationData?, animated: Bool = true) {
        navigate(to: page, data: data, animated: animated)
    }
    
    func popToRootViewController(animated: Bool = true) {
        popToRootViewController(animated: animated)
    }
}
