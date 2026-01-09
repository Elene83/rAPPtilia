import UIKit
import FirebaseAuth

protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator)
}

class AuthCoordinator {
    private let window: UIWindow
    weak var delegate: AuthCoordinatorDelegate?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showLogin()
    }
    
    func showLogin() {
        let loginVC = LoginViewController()
        loginVC.coordinator = self
        let navController = UINavigationController(rootViewController: loginVC)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func showSignUp() {
        guard let navController = window.rootViewController as? UINavigationController else { return }
        let signUpVC = SignUpViewController()
        signUpVC.coordinator = self
        navController.pushViewController(signUpVC, animated: true)
    }
    
    func loginDidSucceed() {
        delegate?.authCoordinatorDidFinish(self)
    }
    
    func signUpDidSucceed() {
        delegate?.authCoordinatorDidFinish(self)
    }
}
