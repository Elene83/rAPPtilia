import SwiftUI

struct TopSideOpened: View {
    var body: some View {
        VStack {
            Image("tinytort")
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(coordinator: MainCoordinator.preview)
    }
}
