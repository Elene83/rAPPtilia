import SwiftUI

struct PasswordChangeView: View {
    @Binding var currentPassword: String
    @Binding var newPassword: String
    @Binding var confirmNewPassword: String
    @FocusState.Binding var focusedField: SettingsView.Field?
    
    let isUpdating: Bool
    let isGoogleUser: Bool
    let onChangePassword: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if isGoogleUser {
                HStack(spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(Color("AppOrange"))
                        .font(.system(size: 16))
                    
                    Text("Password is managed by your Google account, no way to change it here 🦎")
                        .font(.custom("Firago-Regular", size: 14))
                        .foregroundStyle(Color("AppDarkGreen").opacity(0.7))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(Color("AppOrange").opacity(0.1))
                .cornerRadius(4)
                .frame(maxWidth: .infinity)
            } else {
                PasswordField(
                    placeholder: "Current password",
                    text: $currentPassword,
                    focusedField: $focusedField,
                    field: .currentPassword,
                    isDisabled: isUpdating
                )
                
                PasswordField(
                    placeholder: "New password",
                    text: $newPassword,
                    focusedField: $focusedField,
                    field: .newPassword,
                    isDisabled: isUpdating
                )
                
                PasswordField(
                    placeholder: "Confirm new password",
                    text: $confirmNewPassword,
                    focusedField: $focusedField,
                    field: .confirmPassword,
                    isDisabled: isUpdating
                )
                .padding(.bottom, 5)
                
                Button("Change Password") {
                    onChangePassword()
                }
                .disabled(isUpdating)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(isUpdating ? Color("AppOrange").opacity(0.5) : Color("AppOrange"))
                .foregroundStyle(Color("AppStaticBG"))
                .font(.custom("Firago-Regular", size: 16))
                .cornerRadius(4)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

struct PasswordField: View {
    let placeholder: String
    @Binding var text: String
    @FocusState.Binding var focusedField: SettingsView.Field?
    let field: SettingsView.Field
    let isDisabled: Bool
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .font(.custom("Firago-Regular", size: 14))
            .foregroundStyle(Color("AppDarkGreen"))
            .textFieldStyle(.plain)
            .padding(12)
            .background(Color("AppDarkGreen").opacity(isDisabled ? 0.05 : 0.1))
            .cornerRadius(4)
            .focused($focusedField, equals: field)
            .disabled(isDisabled)
    }
}
