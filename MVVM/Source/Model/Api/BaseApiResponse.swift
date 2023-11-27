import Foundation

struct BaseApiResponse<T: Codable>: Codable {
    let code: Int?
    let message: String?
    let data: T?
    let success: Bool?
}
