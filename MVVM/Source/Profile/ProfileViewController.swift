import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileInViewModel = ProfileInViewModel()
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        viewModel.signOut()
        navigateToLoginScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        viewModel.signOut()
    }
    
    private func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let navigationController = UINavigationController(rootViewController: signInController)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = navigationController
        
        
    }
}



extension ProfileViewController: ProfileViewModelDelegate {
    func didSignOut() {
        navigateToLoginScreen()
    }
    
    func didReceiveError() {
        
    }
    
    
}
