import UIKit
import FirebaseCore
import FirebaseMessaging
import FacebookCore
import Core

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        configure()
        configureRemoteNotification(application)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateLocale),
                                               name: NSLocale.currentLocaleDidChangeNotification,
                                               object: nil)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        var page: PageType
        
        let isLoggedIn = AppEnvironment.current.appState.isLoggedIn
        let onBoardingCompleted = AppEnvironment.current.appState.onBoardingCompleted
        
        if isLoggedIn {
            if onBoardingCompleted {
                page = .home
            } else {
                page = .enterPersonalDetails
            }
        } else {
            page = .login
        }
        
        AppEnvironment.current.navigationService.navigate(to: page, data: nil)
        
        return true
    }
    
    private func configure() {
        AppEnvironment.current.navigationService = NavigationService()
        AppEnvironment.current.dialog = Dialog()
        AppEnvironment.configure()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        updateLocale()
    }
    
    @objc private func updateLocale() {
        guard let locale = NSLocale.current.languageCode else {
            return
        }
        
        AppEnvironment.current.preferredLanugage.language = locale
    }
    
    private func configureRemoteNotification(_ application: UIApplication) {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        return [[.alert, .badge, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        AppEnvironment.current.pushNoticationTokenService.update(token: fcmToken)
    }
}

