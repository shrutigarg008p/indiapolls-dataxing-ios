import Network
import Combine

public class NetworkMonitor {
    private let pathMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    
    public let networkStatus = CurrentValueSubject<Bool, Never>(false)
   
    var onWifi = true
    var onCellular = true
    
    var isConnectedToInternet: Bool {
        networkStatus.value
    }

    public init() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }

            networkStatus.send(path.status == .satisfied)
            onWifi = path.usesInterfaceType(.wifi)
            onCellular = path.usesInterfaceType(.cellular)
        }

        startMonitor()
    }
    
    func startMonitor() {
        pathMonitor.start(queue: monitorQueue)
    }
    
    func stopMonitor() {
        pathMonitor.cancel()
    }
}
