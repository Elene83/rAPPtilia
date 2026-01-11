class SignUpViewModel {
    private let signUpUseCase: SignUpUseCase
    
    var onSignUpSuccess: (() -> Void)?
    var onSignUpError: ((String) -> Void)?
    
    init(authRepository: AuthRepository) {
        self.signUpUseCase = SignUpUseCase(authRepository: authRepository)
    }
    
    func signUp(email: String, password: String, fullName: String, username: String) {
        signUpUseCase.execute(email: email, password: password, fullName: fullName, username: username) { [weak self] result in
            switch result {
            case .success:
                self?.onSignUpSuccess?()
            case .failure(let error):
                self?.onSignUpError?(error.localizedDescription)
            }
        }
    }
}
