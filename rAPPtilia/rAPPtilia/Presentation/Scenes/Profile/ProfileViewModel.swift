import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var profile: User?
    
    var isLoggedIn: Bool {
        profile != nil
    }

    private let getFavoriteUseCase: GetFavoritesUseCase
    private let logoutUseCase: LogoutUseCase
    let coordinator: MainCoordinator

    init(profile: User?, getFavoriteUseCase: GetFavoritesUseCase, logoutUseCase: LogoutUseCase, coordinator: MainCoordinator) {
        self.profile = profile
        self.getFavoriteUseCase = getFavoriteUseCase
        self.logoutUseCase = logoutUseCase
        self.coordinator = coordinator
    }
    
    func logOut() {
        logoutUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.coordinator.logout()
                case .failure(let error):
                    print("couldnt log out \(error.localizedDescription)")
                    self?.coordinator.logout()
                }
            }
            
        }
    }
    
    func showAuth() {
        coordinator.logout()
    }
}
