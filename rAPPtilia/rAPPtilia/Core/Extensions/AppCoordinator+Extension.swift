import UIKit

extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidSkip(_ coordinator: AuthCoordinator) {
        createMainCoordinator(with: nil)
    }
    
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        showMainApp()
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorDidLogout(_ coordinator: MainCoordinator) {
        showAuth()
    }
}
