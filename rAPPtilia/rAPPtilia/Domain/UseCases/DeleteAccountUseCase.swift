protocol DeleteAccountUseCaseProtocol {
    func execute(password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class DeleteAccountUseCase: DeleteAccountUseCaseProtocol {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authRepository.deleteAccount(password: password, completion: completion)
    }
}
