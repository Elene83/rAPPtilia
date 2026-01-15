import UIKit
import FirebaseAuth

protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator)
    func authCoordinatorDidSkip(_ coordinator: AuthCoordinator)
}

class AuthCoordinator {
    private let window: UIWindow
    private let authRepository: AuthRepository
    weak var delegate: AuthCoordinatorDelegate?
    
    init(window: UIWindow) {
        self.window = window
        self.authRepository = FirebaseAuthRepository() 
    }
    
    func start() {
        showLogin()
    }
    
    func showLogin() {
        let viewModel = LoginViewModel(authRepository: authRepository)
        let loginVC = LoginViewController(viewModel: viewModel)
        loginVC.coordinator = self
        let navController = UINavigationController(rootViewController: loginVC)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func showSignUp() {
        guard let navController = window.rootViewController as? UINavigationController else { return }
        let viewModel = SignUpViewModel(authRepository: authRepository)
        let signUpVC = SignUpViewController(viewModel: viewModel)
        signUpVC.coordinator = self
        navController.pushViewController(signUpVC, animated: true)
    }
    
    func skipAuth() {
        delegate?.authCoordinatorDidSkip(self)
    }
    
    func loginDidSucceed() {
        delegate?.authCoordinatorDidFinish(self)
    }
    
    func signUpDidSucceed() {
        delegate?.authCoordinatorDidFinish(self)
    }
}
