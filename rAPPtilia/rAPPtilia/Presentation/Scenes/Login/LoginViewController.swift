import UIKit

class LoginViewController: UIViewController {
    weak var coordinator: AuthCoordinator?
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppBG")
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.onLoginSuccess = { [weak self] in
            self?.coordinator?.loginDidSucceed()
        }
        
        viewModel.onLoginError = { [weak self] errorMessage in
            //TODO: handle when ui is built
            print("Login error: \(errorMessage)")
        }
    }
    
    //TODO: call login from vm when ui ready 
}
