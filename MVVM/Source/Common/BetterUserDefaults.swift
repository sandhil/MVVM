import Foundation

enum DeserializationError : Error {
    case classCastError
    case unknownError
}

class BetterUserDefaults {
    
    
    // MARK: ---------------------------------- Properties -----------------------------------------
    
    
    static let standard = BetterUserDefaults(defaults: .standard)
    
    private let defaults: UserDefaults
    
    
    // MARK: ----------------------------------- Lifecycle -----------------------------------------
    
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    
    // MARK: ------------------------------------ Methods ------------------------------------------
    
    
    func contains(key: String) -> Bool {
        return defaults.contains(key: key)
    }
    
    func value<T : Codable>(forKey key: String) throws -> T {

        guard self.contains(key: key) else { throw UserDefaults.Error.noValueForKey }
        
        if isFoundationType(type: T.self) {
            guard let value = defaults.object(forKey: key) as? T else { throw DeserializationError.classCastError }
            return value
        } else {
            return try defaults.codable(forKey: key) as T
        }
    }
    
    func value<T>(forKey key: String) throws -> T {
        guard self.contains(key: key) else { throw UserDefaults.Error.noValueForKey }
        guard let value = defaults.object(forKey: key) as? T else { throw DeserializationError.classCastError }
        return value
    }
    
    func value(forKey key: String) throws -> Any {
        
        guard self.contains(key: key) else { throw UserDefaults.Error.noValueForKey }
        
        let value = defaults.object(forKey: key)!
        
        if "\(type(of: value))" ∈ ["NSTaggedPointerString", "__NSCFString"] {
            return value as! String
        } else {
            return value
        }
    }
    
    // Supports Any or Any subclass containing Data, String, Int, Float, Double, Bool, NSNumber and Arrays / Dictionaries that contain Foundation types and are JSON representable
    // WARNING: Does not support type erased Encodables and non-encodable types!
    func set(_ value: Any?, forKey key: String) {
        
        if value == nil {
            removeValue(forKey: key)
            return
        }
        
        if isFoundationType(value: value) {
            defaults.set(value, forKey: key)
        } else {
            // Arrays or Dictionaries (of Foundation types) that can be expressed as JSON
            let jsonString = try! JSONSerialization.string(withJSONObject: value!, options: [])
            defaults.set(jsonString, forKey: key)
        }
    }
    
    // Supports values whose static type is Encodable (Data, String, Int, Float, Double, Bool and custom Encodable)
    func set<T : Encodable>(_ value: T?, forKey key: String) {
        
        if value == nil {
            removeValue(forKey: key)
            return
        }
        
        if isFoundationType(type: T.self) {
            defaults.set(value, forKey: key)
        } else {
            defaults.set(codable: value!, forKey: key)
        }
    }
    
    func removeValue(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    func rename(key fromKey: String, to toKey: String) throws {
        let value = try self.value(forKey: fromKey)
        set(value, forKey: toKey)
        removeValue(forKey: fromKey)
    }
    
    func dictionaryRepresentation() -> [String : Any] {
        return defaults.dictionaryRepresentation()
    }
    
    
    // MARK: -------------------------------- Private methods --------------------------------------
    
    
    private func isFoundationType<T>(type: T.Type) -> Bool {
        switch T.self {
            case is Data.Type,
                 is String.Type,
                 is Int.Type,
                 is Float.Type,
                 is Double.Type,
                 is Bool.Type,
                 is NSNumber.Type,
                 is Optional<Data>.Type,
                 is Optional<String>.Type,
                 is Optional<Int>.Type,
                 is Optional<Float>.Type,
                 is Optional<Double>.Type,
                 is Optional<Bool>.Type,
                 is Optional<NSNumber>.Type:
                return true
            default:
                return false
        }
    }
    
    private func isFoundationType(value: Any?) -> Bool {
        switch value {
            case is Data,
                 is String,
                 is Int,
                 is Float,
                 is Double,
                 is Bool,
                 is NSNumber:
                return true
            default:
                return false
        }
    }
    
}

extension BetterUserDefaults {
    
    func data(forKey key: String) throws -> Data {
        return try value(forKey: key)
    }
    
    func string(forKey key: String) throws -> String {
        return try value(forKey: key)
    }
    
    func int(forKey key: String) throws -> Int {
        return try value(forKey: key)
    }
    
    func json(forKey key: String, options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try string(forKey: key).toJSON(options: options)
    }
    
    func jsonObject(forKey key: String) throws -> [String : Any] {
        return try string(forKey: key).toJSONObject()
    }
    
    func jsonArray(forKey key: String) throws -> [Any] {
        return try string(forKey: key).toJSONArray()
    }
    
}
