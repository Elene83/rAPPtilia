import UIKit

class SignUpUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String, fullName: String, username: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard !email.isEmpty, !password.isEmpty, !fullName.isEmpty, !username.isEmpty else {
            completion(.failure(NSError(domain: "ValidationError", code: -1, userInfo: [NSLocalizedDescriptionKey: "All fields are required"])))
            return
        }
        
        guard password.count >= 6 else {
            completion(.failure(NSError(domain: "ValidationError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Password must be at least 6 characters"])))
            return
        }
        
        authRepository.signUp(email: email, password: password, fullName: fullName, username: username, completion: completion)
    }
}
