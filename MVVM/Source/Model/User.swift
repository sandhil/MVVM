
import Foundation

struct User : Codable {
    var fullName: String?
    let userId: String?
    let email: String?
}

extension BetterUserDefaults {
    
    var user: User? {
        get { return try? value(forKey: "user") }
        set(value) { set(value, forKey: "user") }
    }
    
}
