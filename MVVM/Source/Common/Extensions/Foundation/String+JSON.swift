import Foundation

extension String {
    
    func toJSON(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try self.data(using: .utf8)!.toJSON(options: options)
    }
    
    func toJSONObject(options: JSONSerialization.ReadingOptions = []) throws -> [String : Any] {
        return try self.data(using: .utf8)!.toJSONObject(options: options)
    }
    
    func toJSONArray(options: JSONSerialization.ReadingOptions = []) throws -> [Any] {
        return try self.data(using: .utf8)!.toJSONArray(options: options)
    }
    
}
