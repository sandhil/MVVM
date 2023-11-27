import Foundation

extension UserDefaults {
    
    enum Error : Swift.Error {
        case noValueForKey
    }
    
}

extension UserDefaults {
    
    public func codable<T: Decodable>(forKey key: String, using decoder: JSONDecoder = JSONDecoder()) throws -> T {
        guard self.contains(key: key) else { throw UserDefaults.Error.noValueForKey }
        guard let jsonString = string(forKey: key) else { throw DeserializationError.classCastError }
        let data = jsonString.data(using: .utf8)!
        return try decoder.decode(T.self, from: data)
    }
    
    public func set<T: Encodable>(codable: T?, forKey key: String, using encoder: JSONEncoder = JSONEncoder()) {
        if codable == nil {
            removeObject(forKey: key)
        } else {
            let data = try! encoder.encode(codable!)
            let jsonString = String(data: data, encoding: .utf8)
            set(jsonString, forKey: key)
        }
    }
    
    func contains(key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
