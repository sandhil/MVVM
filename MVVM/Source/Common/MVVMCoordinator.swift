import UIKit
import Swinject

class MVVMCoordinator {
    
    private var sessionManager: SessionManager? = nil
    private let defaults = BetterUserDefaults(defaults: UserDefaults.standard)
    
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        sessionManager = Container.sharedContainer.resolve(SessionManager.self)
        setInitialScreen()
        
    }
    
    func setInitialScreen() {
        if sessionManager?.isLoggedIn == true {
            navigateToHome()
        } else {
            navigateToLogin()
        }
    }
    
    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        let navigationController = UINavigationController(rootViewController: tabbarController)
        window?.rootViewController = navigationController
    }
    
    func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let navigationController = UINavigationController(rootViewController: signInController)
        window?.rootViewController = navigationController
    }
}

extension Container {
    static let sharedContainer: Container = {
        let container = Container()
        let defaults = BetterUserDefaults(defaults: UserDefaults.standard)
        let baseURL = Constants.baseURL
        let apiClient = ApiClient(baseURL: baseURL)
        let sessionManager = SessionManager(defaults: defaults)
        
        container.register(SessionManager.self) { _ in
            sessionManager
        }
        
        container.register(BetterUserDefaults.self) { _ in
            defaults
        }
        return container
    }()
    
    
}
