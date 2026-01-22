import UIKit

protocol DeleteAccountUseCaseProtocol {
    func execute(password: String?, presentingViewController: UIViewController?, completion: @escaping (Result<Void, Error>) -> Void)
}

class DeleteAccountUseCase: DeleteAccountUseCaseProtocol {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(password: String?, presentingViewController: UIViewController?, completion: @escaping (Result<Void, Error>) -> Void) {
        authRepository.deleteAccount(password: password, presentingViewController: presentingViewController, completion: completion)
    }
}
