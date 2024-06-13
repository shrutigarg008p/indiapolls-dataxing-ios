public class AppState {
    private let storage: AppStorage
    
    public init(storage: AppStorage) {
        self.storage = storage
    }

    public var isLoggedIn: Bool {
        guard let auth, !auth.token.isEmpty else {
            return false
        }
        
        return true
    }
    
    public var auth: AuthDto! {
        get {
            storage.restore(forKey: StorageKeys.auth.rawValue)
        }
        set {
            if newValue != nil {
                save(newValue)
            }
        }
    }
    
    public var onBoardingCompleted: Bool {
        get {
            return (auth?.basicProfile)?.hasValue ?? false
        }
    }
    
    private func save(_ auth: AuthDto) {
        storage.save(value: auth, forKey: StorageKeys.auth.rawValue)
    }
        
    func clear() {
        auth = nil
        storage.delete(forKey: StorageKeys.auth.rawValue)
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}
