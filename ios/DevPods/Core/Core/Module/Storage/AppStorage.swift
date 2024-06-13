import Networking

public class AppStorage: AccessTokenStorage {
    private let defaults = UserDefaults.standard
    
    public var accessToken: String {
        getAccessToken()
    }
    
    func save<T: Codable>(value: T, forKey: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(value)
            defaults.set(data, forKey: forKey)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func restore<T: Codable>(forKey: String) -> T? {
        guard let data = defaults.data(forKey: forKey) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let value = try decoder.decode(T.self, from: data)
            return value
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func delete(forKey: String) {
        defaults.removeObject(forKey: forKey)
    }
    
    private func getAccessToken() -> String {
        if let token: AuthDto? = restore(forKey: StorageKeys.auth.rawValue), let token {
            return token.token
        }
        
        return String.empty
    }
    
    deinit {
        print("\(String(describing: self)) is being deinitialised")
    }
}
