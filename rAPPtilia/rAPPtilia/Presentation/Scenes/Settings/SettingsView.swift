import SwiftUI

struct SettingsView: View {
    //MARK: Properties
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
                        isGoogleUser: vm.isGoogleUser,
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
                    VStack() {
                        Image("smolliz")
                            .padding(.top, 40)
                            .padding(.bottom, 35)
                                            
                        Text("You are not logged in")
                            .font(.custom("Firago-Regular", size: 16))
                            .foregroundStyle(Color("AppOrange"))
                            .padding(.bottom, 20)
                                            
                        Button("Log In") {
                                vm.showAuth()
                            }
                            .font(.custom("Firago-Medium", size: 18))
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
            if !vm.isGoogleUser {
                SecureField("Password", text: $vm.deleteAccountPassword)
            }
            Button("Changed my mind", role: .cancel) {
                vm.deleteAccountPassword = ""
            }
            Button("Finalize deletion", role: .destructive) {
                vm.deleteAccount()
            }
        } message: {
            if vm.isGoogleUser {
                Text("One lassst time, this action cannot be undone 🐍")
            } else {
                Text("Pleassse enter your password to confirm account deletion 🐍")
            }
        }
        .onTapGesture {
            focusedField = nil
            vm.clearMessages()
        }
    }
    
    private func getRootVC() -> UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
    
    private func handleThemeChange(_ option: ThemeManager.ThemeOption) {
        if option == .system {
            vm.setSystemTheme()
        } else {
            vm.setColorScheme(option == .dark ? .dark : .light)
        }
    }
}
