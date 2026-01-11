import Foundation

class LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            completion(.failure(NSError(domain: "ValidationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Email and password cannot be empty"])))
            return
        }
        
        authRepository.login(email: email, password: password, completion: completion)
    }
}
