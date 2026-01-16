import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var isUpdating = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var confirmNewPassword = ""
    
    @Published var deleteAccountPassword = ""
    @Published var showDeleteConfirmation = false
    
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
        changePasswordUseCase: ChangePasswordUseCase,
        deleteAccountUseCase: DeleteAccountUseCase,
        coordinator: MainCoordinator
    ) {
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
    
    func changePassword() {
        guard !currentPassword.isEmpty, !newPassword.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        guard newPassword == confirmNewPassword else {
            errorMessage = "New passwords don't match"
            return
        }
        
        guard newPassword.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
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

        deleteAccountUseCase.execute(password: deleteAccountPassword) { [weak self] result in
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
}
