import Foundation

class Preferences {
    private static let defaults = UserDefaults.standard

    static var isFirstTimeInstall : Bool {
        get {
            return defaults.bool(forKey:  StorageKeys.isFirstTimeInstall.rawValue)
        } set {
            defaults.set(newValue, forKey: StorageKeys.isFirstTimeInstall.rawValue)
        }
    }
}
