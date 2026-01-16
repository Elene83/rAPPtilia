import SwiftUI

struct DeleteAccountView: View {
    let isUpdating: Bool
    let onDeleteAccount: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Button("Delete Account") {
                onDeleteAccount()
            }
            .disabled(isUpdating)
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .background(Color("AppStaticRed"))
            .foregroundStyle(Color("AppStaticBG"))
            .font(.custom("Firago-Regular", size: 16))
            .cornerRadius(4)
            .frame(maxWidth: .infinity)
        }
    }
}
