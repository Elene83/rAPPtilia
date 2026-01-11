import UIKit

class LoginViewModel {
    private let loginUseCase: LoginUseCase
    private let authRepository: AuthRepository
    
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.loginUseCase = LoginUseCase(authRepository: authRepository)
    }
    
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
