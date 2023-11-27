import Foundation
import Swinject

protocol SignInViewModelDelegate: AnyObject {
    func didSignIn()
    func didReceiveError()
}

class SignInViewModel {
    
    var sessionManager: SessionManager!
    weak var delegate: SignInViewModelDelegate?
    
    init() {
        sessionManager = Container.sharedContainer.resolve(SessionManager.self)
    }
    
    func signIn(userName: String) {
        let user = User(userId: userName, email: "")
        sessionManager.setUSer(user: user)
        sessionManager.isLoggedIn = true
        delegate?.didSignIn()
    }
}
