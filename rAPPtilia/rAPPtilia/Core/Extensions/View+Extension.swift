import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

extension View {
    func getNavigationController() -> UINavigationController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = scene.windows.first?.rootViewController,
              let tabBarController = rootVC as? UITabBarController,
              let navController = tabBarController.selectedViewController as? UINavigationController else {
            return nil
        }
        return navController
    }
}
