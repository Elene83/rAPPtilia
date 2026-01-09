import UIKit

class SignUpViewController: UIViewController {
    weak var coordinator: AuthCoordinator?
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppBG")
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.onSignUpSuccess = { [weak self] in
            self?.coordinator?.signUpDidSucceed()
        }
        
        viewModel.onSignUpError = { [weak self] errorMessage in
            //TODO: handle after ui
            print("Sign up error: \(errorMessage)")
        }
    }
    
    //TODO: call sign up from vm when ui ready
}
