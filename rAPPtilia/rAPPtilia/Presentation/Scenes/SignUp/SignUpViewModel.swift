class SignUpViewModel {
    //MARK: Properties
    private let signUpUseCase: SignUpUseCase
    
    var onSignUpSuccess: (() -> Void)?
    var onSignUpError: ((String) -> Void)?
    
    //MARK: Inits
    init(authRepository: AuthRepository) {
        self.signUpUseCase = SignUpUseCase(authRepository: authRepository)
    }
    
    //MARK: Methods
    func signUp(email: String, password: String, fullName: String, username: String) {
        LoaderManager.shared.show()
        signUpUseCase.execute(email: email, password: password, fullName: fullName, username: username) { [weak self] result in
            LoaderManager.shared.hide()
            switch result {
            case .success:
                self?.onSignUpSuccess?()
            case .failure(let error):
                self?.onSignUpError?(error.localizedDescription)
            }
        }
    }
}
