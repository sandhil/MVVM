import Foundation

extension Encodable {
    
    func toDictionary() -> [String:Any] {
        let jsonData = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
    }
    
}
