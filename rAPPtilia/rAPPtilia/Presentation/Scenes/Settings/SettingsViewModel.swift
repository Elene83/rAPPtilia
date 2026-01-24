import SwiftUI
import FirebaseAuth

final class SettingsViewModel: ObservableObject {
    @Published var isUpdating = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""
    
    @Published var deleteAccountPassword = ""
    @Published var showDeleteConfirmation = false
    
    var profile: User?
    
    var isLoggedIn: Bool {
        profile != nil
    }
    
    var isGoogleUser: Bool {
        Auth.auth().currentUser?.providerData.contains { $0.providerID == "google.com" } ?? false
    }
    
    private let changePasswordUseCase: ChangePasswordUseCaseProtocol
    private let deleteAccountUseCase: DeleteAccountUseCaseProtocol
    let coordinator: MainCoordinator
    let themeManager = ThemeManager.shared
    
    var selectedTheme: ColorScheme {
        themeManager.selectedTheme
    }
    
    var themeOption: ThemeManager.ThemeOption {
        themeManager.themeOption
    }
    
    init(
        profile: User? = nil,
        changePasswordUseCase: ChangePasswordUseCase,
        deleteAccountUseCase: DeleteAccountUseCase,
        coordinator: MainCoordinator
    ) {
        self.profile = profile
        self.changePasswordUseCase = changePasswordUseCase
        self.deleteAccountUseCase = deleteAccountUseCase
        self.coordinator = coordinator
    }
    
    func setColorScheme(_ scheme: ColorScheme) {
        themeManager.setColorScheme(scheme)
    }
    
    func setSystemTheme() {
        themeManager.setSystemTheme()
    }
    
    func validatePassword(_ password: String) -> String? {
        guard password.count >= 6 else {
            return "Password must be at least 6 characters"
        }
        
        guard password.rangeOfCharacter(from: .uppercaseLetters) != nil else {
            return "Password must incude at least one uppercase character"
        }
        
        guard password.rangeOfCharacter(from: .decimalDigits) != nil else {
            return "Password must contain at least one number"
        }
        
        return nil
    }
    
    func changePassword() {
        guard !currentPassword.isEmpty, !newPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        guard newPassword == confirmNewPassword else {
            errorMessage = "New passwords don't match"
            return
        }
        
        if let validationError = validatePassword(newPassword) {
            errorMessage = validationError
            return
        }
        
        isUpdating = true
        errorMessage = nil
        successMessage = nil
        
        changePasswordUseCase.execute(currentPassword: currentPassword, newPassword: newPassword) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUpdating = false
                
                switch result {
                case .success:
                    self?.successMessage = "Password changed successfully"
                    self?.currentPassword = ""
                    self?.newPassword = ""
                    self?.confirmNewPassword = ""
                case .failure(let error):
                    self?.errorMessage = "Failed to change password: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func deleteAccount() {
        isUpdating = true
        errorMessage = nil
        
        let viewController = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
        
        let password = isGoogleUser ? nil : deleteAccountPassword

        deleteAccountUseCase.execute(password: password, presentingViewController: viewController) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUpdating = false

                switch result {
                case .success:
                    self?.coordinator.logout()
                case .failure(let error):
                    self?.errorMessage = "Failed to delete account: \(error.localizedDescription)"
                    self?.showDeleteConfirmation = false
                }
            }
        }
    }
    
    func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }
    
    func showAuth() {
        coordinator.logout()
    }
}
