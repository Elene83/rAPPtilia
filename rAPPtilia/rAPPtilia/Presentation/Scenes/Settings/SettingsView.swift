import SwiftUI

struct SettingsView: View {
    @StateObject var vm: SettingsViewModel
    @FocusState private var focusedField: Field?
    @State private var showDeleteWarning = false
    
    enum Field {
        case currentPassword, newPassword, confirmPassword, deletePassword
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                ColorSchemeView { option in
                    handleThemeChange(option)
                }
                
                if vm.isLoggedIn {
                    Divider()
                        .background(Color("AppDarkGreen").opacity(0.3))
                    
                    PasswordChangeView(
                        currentPassword: $vm.currentPassword,
                        newPassword: $vm.newPassword,
                        confirmNewPassword: $vm.confirmNewPassword,
                        focusedField: $focusedField,
                        isUpdating: vm.isUpdating,
                        onChangePassword: {
                            vm.changePassword()
                            focusedField = nil
                        }
                    )
                    
                    Divider()
                        .background(Color("AppDarkGreen").opacity(0.3))
                    
                    DeleteAccountView(
                        isUpdating: vm.isUpdating,
                        onDeleteAccount: { showDeleteWarning = true }
                    )
                    
                    StatusView(
                        isUpdating: vm.isUpdating,
                        errorMessage: vm.errorMessage,
                        successMessage: vm.successMessage
                    )
                } else {
                    VStack(spacing: 16) {
                        Image("darkgreenliz")
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                                            
                        Text("Log in to manage your account")
                            .font(.custom("Firago-Regular", size: 16))
                            .foregroundStyle(Color("AppDarkGreen").opacity(0.6))
                                            
                        Button("Log In") {
                                vm.showAuth()
                            }
                            .font(.custom("Firago-Medium", size: 20))
                            .foregroundStyle(Color("AppDarkGreen"))
                        }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBG"))
        .alert("Delete account?", isPresented: $showDeleteWarning) {
            Button("Nevermind", role: .cancel) { }
            Button("Proceed", role: .destructive) {
                vm.showDeleteConfirmation = true
            }
        } message: {
            Text("This action cannot be undone! All your data will be PERMANENTLY deleted 🐉")
        }
        .alert("", isPresented: $vm.showDeleteConfirmation) {
            SecureField("Password", text: $vm.deleteAccountPassword)
            Button("Changed my mind", role: .cancel) {
                vm.deleteAccountPassword = ""
            }
            Button("Finalize deletion", role: .destructive) {
                vm.deleteAccount()
            }
        } message: {
            Text("Pleassse enter your password to confirm account deletion 🐍")
        }
        .onTapGesture {
            focusedField = nil
            vm.clearMessages()
        }
    }
    
    private func handleThemeChange(_ option: ThemeManager.ThemeOption) {
        if option == .system {
            vm.setSystemTheme()
        } else {
            vm.setColorScheme(option == .dark ? .dark : .light)
        }
    }
}
