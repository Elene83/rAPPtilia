import UIKit

class LoginViewModel {
    //MARK: Properties
    private let loginUseCase: LoginUseCase
    private let authRepository: AuthRepository
    
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    
    //MARK: Inits
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.loginUseCase = LoginUseCase(authRepository: authRepository)
    }
    
    //MARK: Methods
    func login(email: String, password: String) {
        loginUseCase.execute(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.onLoginSuccess?()
            case .failure(let error):
                self?.onLoginError?(error.localizedDescription)
            }
        }
    }
    
    func signInWithGoogle(presentingViewController: UIViewController) {
        authRepository.signInWithGoogle(presentingViewController: presentingViewController) { [weak self] result in
            switch result {
            case .success:
                self?.onLoginSuccess?()
            case .failure(let error):
                self?.onLoginError?(error.localizedDescription)
            }
        }
    }
}
