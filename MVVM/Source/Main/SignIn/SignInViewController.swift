import Foundation
import UIKit

class SignInViewController: UIViewController {
    
    var viewModel: SignInViewModel = SignInViewModel()
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        viewModel.delegate = self
        viewModel.signIn(userName: userNameTextField.text ?? "")
        navigateToHomeScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func navigateToHomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarController = storyboard.instantiateViewController(withIdentifier: "TabbarController") as! TabbarController
        self.navigationController?.pushViewController(tabbarController, animated: false)
    }
}


extension SignInViewController: SignInViewModelDelegate {
    func didSignIn() {
        navigateToHomeScreen()
    }
    
    func didReceiveError() {
        
    }
    
    
}
