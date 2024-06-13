public class AppEnvironment {
    private init() {}
    
    public static var current = AppEnvironment()

    public var navigationService: NavigationProtocol!
    public var storage: AppStorage!
    public var api: ApiService!
    public var appState: AppState!
    public var preferredLanugage: PreferredLanguage!
    public var dialog: DialogProtocol!
    public var pushNoticationTokenService: PushNotificationTokenService!

    public static func configure() {
        let storage = AppStorage()
        
        current.storage = storage
        current.preferredLanugage = PreferredLanguage(storage: storage)
        current.appState = AppState(storage: storage)
        current.api = ApiService(accessTokenStorage: storage, langauageStorage: current.preferredLanugage)
        
        let pns = PushNotificationTokenService()
        pns.initialize()
        current.pushNoticationTokenService = pns
    }
}
