
import Foundation
import RxSwift
import Alamofire
import KeychainAccess

class BackendClient {
    
    private let apiClient: ApiClient
    private let keychain: Keychain
    
    init(apiClient: ApiClient, keychain: Keychain) {
        self.apiClient = apiClient
        self.keychain = keychain
    }
    
    func load<T: Codable>(request: ApiRequest) -> Single<T> {
        return apiClient.loadRequest(apiRequest: request)
    }
    
    
    func loadArrayRequest<T: Codable>(request: ApiRequest) -> Single<[T]> {
        return apiClient.loadArrayRequest(apiRequest: request)
    }
    
    func loadDataRequest(request: ApiRequest) -> Single<DataRequest> {
        return apiClient.loadDataRequest(apiRequest: request)
            .subscribe(on: Schedulers.io)
    }
    
    func setAccessToken(token: String, refreshToken: String? = nil) {
        do {
            try keychain.set(token, key: Constants.accessToken)
            try keychain.set(refreshToken ?? "", key: Constants.refreshToken)
            
        }
        catch let error {
            print(error)
        }
        apiClient.setAccessToken(token: token, refreshToken: refreshToken ?? "")
    }
    
}

extension Error {
    
    func isUnauthorized() -> Bool {
        return statusCode ∈ [401]
    }
    
    var statusCode: Int {
        
        guard let afError = self as? AFError else {
            return (self as NSError).userInfo["statusCode"] as? Int ?? -1
        }
        return afError.responseCode ?? 401
        
    }
}

extension Single {
    
    func catchUnauthorized(handler: @escaping () -> Single<Element>) -> Single<Element> {
        return self
            .asObservable()
            .catch { error in
                if error.isUnauthorized() {
                    return handler().asObservable()
                } else {
                    return Observable.error(error)
                }
            }
            .asSingle()
    }
    
}
