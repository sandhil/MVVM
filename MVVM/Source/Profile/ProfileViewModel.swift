import Foundation
import Swinject

protocol ProfileViewModelDelegate: AnyObject {
    func didSignOut()
    func didReceiveError()
}

class ProfileInViewModel {
    
    var sessionManager: SessionManager!
    weak var delegate: ProfileViewModelDelegate?
    
    init() {
        sessionManager = Container.sharedContainer.resolve(SessionManager.self)
    }
    
    func signOut() {
        sessionManager.setUSer(user: nil)
        sessionManager.isLoggedIn = false
        delegate?.didSignOut()
    }
}
