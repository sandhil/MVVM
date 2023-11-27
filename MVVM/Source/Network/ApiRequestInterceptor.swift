import Alamofire
import KeychainAccess
import Foundation
import RxAlamofire
import RxSwift


class ApiRequestInterceptor: RequestInterceptor {
    
    let baseURL: URL?
    let keychain = Keychain()
    var isForceFullyLoggedOut = false
    
    private var accessToken: String? {
        didSet {
            do {
                try keychain.set(accessToken ?? "", key: Constants.accessToken)
            }
            catch let error {
                print(error)
            }
        }
    }
    
    private var refreshToken: String? {
        didSet {
            do {
                try keychain.set(refreshToken ?? "", key: Constants.refreshToken)
            }
            catch let error {
                print(error)
            }
        }
    }
    
    init(baseURL: URL? = nil) {
        self.baseURL = baseURL
        let accessToken = keychain[Constants.accessToken]
        let refreshToken = keychain[Constants.refreshToken]
        
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if accessToken != nil && accessToken != "" {
            let bearerToken = "Bearer \(accessToken ?? "")"
            urlRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
        
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        if isForceFullyLoggedOut {
            return
        }
        let response = request.task?.response as? HTTPURLResponse
        switch response?.statusCode ?? -1 {
        case 401:
            authenticate { result in
                completion(result)
            }
        default:
            completion(.doNotRetryWithError(error))
        }
    }
    
    func authenticate(completion: @escaping (RetryResult) -> Void) {
        getOrRefreshToken(isRefreshToken: accessToken != "") { retryResult in
            completion(retryResult)
            
        }
    }
    
    private func path(_ path: String) -> String {
        return (baseURL != nil) ? "\(baseURL!.absoluteString)\(path)" : "http://18.116.171.113:3000/api/v1/\(path)"
    }
    
    func getOrRefreshToken (isRefreshToken: Bool, completion: @escaping (RetryResult) -> Void) {
        makeRequest(isRefreshToken: isRefreshToken) { retryResult in
            completion(retryResult)
        }
    }
    
    func makeRequest(isRefreshToken: Bool, completion: @escaping (RetryResult) -> Void) {
        var headers = HTTPHeaders()
        headers.add(name: "Authorization", value: "Bearer \(accessToken ?? "")")
        
        let param = ["refreshToken": refreshToken ?? "",
                     "id": BetterUserDefaults(defaults: UserDefaults.standard).user?.userId ?? ""] as! [String: Any]
        
        AF.request(path("refresh"), method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                print(response)
                switch response.response?.statusCode {
                case 200 :
                    if let data = response.data {
                        do {
                            let refreshTokenResponse = try JSONDecoder().decode(BaseApiResponse<UserResponse>.self, from: data)
                            self.accessToken = refreshTokenResponse.data?.accessToken
                            self.refreshToken = refreshTokenResponse.data?.refreshToken
                            completion(.retry)
                        } catch {
                            completion(.doNotRetry)
                        }
                    } else {
                        completion(.doNotRetry)
                    }
                case 401:
                    completion(.doNotRetry)
                    
                default:
                    completion(.doNotRetry)
                }
                
            }
    }
    
    func setTokens(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
