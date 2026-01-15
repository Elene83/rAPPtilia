import Foundation

class LogoutUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(completion: @escaping (Result<Void, Error>) -> Void) {
        authRepository.logout(completion: completion)
    }
}
