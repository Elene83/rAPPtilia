import SwiftUI

struct ChatView: View {
    let coordinator: MainCoordinator

    var body: some View {
        VStack(spacing: 0) {
            TopSide()
            Prompts()
            Spacer()
            TextInput()
                .padding(.horizontal, 20)
                .padding(.bottom, 25)
        }
        .padding(.top, -80)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("AppBG"))
        .hideKeyboardOnTap()
    }
}
