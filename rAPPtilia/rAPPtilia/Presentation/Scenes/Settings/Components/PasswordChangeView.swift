import SwiftUI

struct PasswordChangeView: View {
    @Binding var currentPassword: String
    @Binding var newPassword: String
    @Binding var confirmNewPassword: String
    @FocusState.Binding var focusedField: SettingsView.Field?
    
    let isUpdating: Bool
    let onChangePassword: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            PasswordField(
                placeholder: "Current password",
                text: $currentPassword,
                focusedField: $focusedField,
                field: .currentPassword
            )
            
            PasswordField(
                placeholder: "New password",
                text: $newPassword,
                focusedField: $focusedField,
                field: .newPassword
            )
            
            PasswordField(
                placeholder: "Confirm new password",
                text: $confirmNewPassword,
                focusedField: $focusedField,
                field: .confirmPassword
            )
            .padding(.bottom, 5)
            
            Button("Change Password") {
                onChangePassword()
            }
            .disabled(isUpdating)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(Color("AppOrange"))
            .foregroundStyle(Color("AppStaticBG"))
            .font(.custom("Firago-Regular", size: 16))
            .cornerRadius(4)
            .frame(maxWidth: .infinity)
        }
    }
}

struct PasswordField: View {
    let placeholder: String
    @Binding var text: String
    @FocusState.Binding var focusedField: SettingsView.Field?
    let field: SettingsView.Field
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .font(.custom("Firago-Regular", size: 14))
            .foregroundStyle(Color("AppDarkGreen"))
            .textFieldStyle(.plain)
            .padding(12)
            .background(Color("AppDarkGreen").opacity(0.1))
            .cornerRadius(4)
            .focused($focusedField, equals: field)
    }
}
