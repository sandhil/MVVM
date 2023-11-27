import Foundation

struct UserResponse : Codable {
    var userId: String?
    var fullName: String?
    var email: String?
    var accessToken: String?
    var refreshToken: String?
    
    func toUser() -> User {
        return User(fullName: fullName, userId: userId, email: email)
    }
}
