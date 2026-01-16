protocol ChangePasswordUseCaseProtocol {
    func execute(currentPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class ChangePasswordUseCase: ChangePasswordUseCaseProtocol {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(currentPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authRepository.changePassword(currentPassword: currentPassword, newPassword: newPassword, completion: completion)
    }
}
