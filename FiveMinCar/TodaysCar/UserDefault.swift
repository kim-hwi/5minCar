import Foundation

@propertyWrapper
struct UserDefault {
    private let key: String
    private let defaultValue: String
    
    init(key: String, defaultValue: String = "") {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: String {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                return defaultValue
            }
            guard let token = try? JSONDecoder().decode(String.self, from: data) else {
                return defaultValue
            }
            return token
        }
        set {
            guard let encoded = try? JSONEncoder().encode(newValue) else {
                return
            }
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
