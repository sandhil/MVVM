import Foundation

extension JSONSerialization {
    
    static func string(withJSONObject obj: Any, options: JSONSerialization.WritingOptions, encoding: String.Encoding = .utf8) throws -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: obj, options: options)
            return data.toString(encoding: encoding)
        } catch {
            throw error
        }
    }
    
}
