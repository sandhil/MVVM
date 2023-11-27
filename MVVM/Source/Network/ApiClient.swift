

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

struct ApiRequest {
    
    let method: HTTPMethod
    let endPoint: EndPoint
    var parameters: [String: Any]? = nil
    var encoding: ParameterEncoding = JSONEncoding.default
    
}

class ApiClient {
    
    var session: Session?
    let baseURL: URL?
    var headers: HTTPHeaders?
    var accessToken: String?
    var refreshToken: String?
    private let defaults = BetterUserDefaults(defaults: UserDefaults.standard)
    
    let interceptor: ApiRequestInterceptor!
    
    init(baseURL: URL? = nil) {
        self.baseURL = baseURL
        interceptor = ApiRequestInterceptor(baseURL: baseURL)
        session = Session(interceptor: self.interceptor)
        headers = headerData()
    }
    
    func loadArrayRequest<T: Codable>(apiRequest: ApiRequest) -> Single<[T]> {
        return request(apiRequest.method, path(apiRequest.endPoint.description), parameters: apiRequest.parameters, encoding: apiRequest.encoding, headers: headers, interceptor: interceptor)
            .validate { request, response, data in
                let statusCode  = response.statusCode
                 if (statusCode <= 299 && statusCode >= 200) || statusCode == 422 {
                     return .success(())
                 } else {
                     let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: response.statusCode))
                     return .failure(error)
                 }
             }
            .responseString()
            .map { response, dataString in
                guard let jsonData = dataString.data(using: String.Encoding.utf8) else { throw APIError.apiError("data not found") }
                let baseApiResponse = try JSONDecoder().decode(BaseApiResponse<[T]>.self, from: jsonData)
                return baseApiResponse.data!
            }
            .asSingle()
    }
    
    func loadDataRequest(apiRequest: ApiRequest) -> Single<DataRequest> {
        return request(apiRequest.method, path(apiRequest.endPoint.description), parameters: apiRequest.parameters, encoding: apiRequest.encoding, headers: headers, interceptor: interceptor)
            .validate { request, response, data in
                let statusCode  = response.statusCode
                 if (statusCode <= 299 && statusCode >= 200) || statusCode == 422 || statusCode == 400 {
                     return .success(())
                 } else {
                     let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: response.statusCode))
                     return .failure(error)
                 }
            }
            .asSingle()
    }
    
    func loadRequest<T: Codable>(apiRequest: ApiRequest) -> Single<T> {
        headers = headerData()
        return request(apiRequest.method, path(apiRequest.endPoint.description), parameters: apiRequest.parameters, encoding: apiRequest.encoding, headers: headers, interceptor: interceptor)
            .validate { request, response, data in
                let statusCode  = response.statusCode
                 if (statusCode <= 299 && statusCode >= 200) || statusCode == 422 {
                     return .success(())
                 } else if statusCode == 401 {
                     let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: response.statusCode))
                     return .failure(error)
                 } else {
                     return .success(())
                 }
             }
            .responseString()
            .map { response, dataString in
                let jsonData = dataString.data(using: String.Encoding.utf8)!
                let baseApiResponse = try JSONDecoder().decode(BaseApiResponse<T>.self, from: jsonData)
                guard let data = baseApiResponse.data else { throw APIError.apiError("") }
                return data
            }
            .asSingle()
    }
    
    private func path(_ path: String) -> String {
        return (baseURL != nil) ? "\(baseURL!.absoluteString)\(path)" : path
    }
    
    func headerData() -> HTTPHeaders {
        var header = HTTPHeaders()
        
        if (accessToken != nil) {
            header.add(name: "Authorization", value: "Bearer \(accessToken ?? "")")
        }
        return header
    }
    
    func setAccessToken(token: String, refreshToken: String) {
        accessToken = token
        self.refreshToken = refreshToken
        interceptor.setTokens(accessToken: token, refreshToken: refreshToken)
    }
    
}

enum EndPoint: CustomStringConvertible {
    
    case login
    case register
    
    var description: String {
        switch self {
        case .login: return "login"
        case .register: return "register-user"
        }
    }
}

enum DecodableError: Error {
    case illegalInput
}

extension Decodable {
    
    static func fromJSON(_ string: String?) throws -> Self {
        guard string != nil else { throw DecodableError.illegalInput }
        let data = string!.data(using: .utf8)!
        return try JSONDecoder().decode(self, from: data)
    }
    
}

enum APIError: Error {
    case apiError(String)
}

enum RefreshTokenError: Error {
    case refreshTokenExpired(String)
}
