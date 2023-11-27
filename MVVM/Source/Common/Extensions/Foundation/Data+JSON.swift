import Foundation

extension Data {
    
    func toJSON(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
    
    func toJSONObject(options: JSONSerialization.ReadingOptions = []) throws -> [String : Any] {
        let JSONValue = try self.toJSON()
        guard let JSONObject = JSONValue as? [String : Any] else {
            throw DeserializationError.classCastError
        }
        return JSONObject
    }
    
    func toJSONArray(options: JSONSerialization.ReadingOptions = []) throws -> [Any] {
        let JSONValue = try self.toJSON()
        guard let JSONArray = JSONValue as? [Any] else {
            throw DeserializationError.classCastError
        }
        return JSONArray
    }
 
}
