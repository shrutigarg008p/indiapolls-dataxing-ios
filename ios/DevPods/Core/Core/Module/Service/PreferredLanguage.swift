import Networking

public class PreferredLanguage: LanguageStorage {
    private let storage: AppStorage
    private let defaultLanguage = "en"
    
    public init(storage: AppStorage) {
        self.storage = storage
    }

    public var language: String {
        get {
            storage.restore(forKey: StorageKeys.language.rawValue) ?? defaultLanguage
        }
        set {
            save(newValue)
        }
    }
    
    private func save(_ language: String) {
        storage.save(value: language, forKey: StorageKeys.language.rawValue)
    }
    
    func clear() {
        language = defaultLanguage
        storage.delete(forKey: StorageKeys.auth.rawValue)
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}
