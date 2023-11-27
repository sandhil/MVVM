
import Foundation
import RxSwift
import Alamofire

class SessionManager {
    let defaults: BetterUserDefaults
    init(defaults: BetterUserDefaults) {
        self.defaults = defaults
        self.user = defaults.user
    }
    
    private(set) var user: User? = nil {
        didSet {
            defaults.user = user
        }
    }
    
    var isOnboardingShown: Bool? {
        get { return try? defaults.value(forKey: "isOnboardingShown") }
        set { defaults.set(newValue, forKey: "isOnboardingShown") }
    }
    
    var isLoggedIn: Bool? {
        get { return try? defaults.value(forKey: "isLoggedIn") }
        set { defaults.set(newValue, forKey: "isLoggedIn") }
    }
        
    func setUSer(user: User?) {
        self.user = user
    }
}
