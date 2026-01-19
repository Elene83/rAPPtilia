import UIKit
import FirebaseAuth

class AppCoordinator {
    private let window: UIWindow
    private var authCoordinator: AuthCoordinator?
    private var mainCoordinator: MainCoordinator?
    private var authRepository: AuthRepository
    
    init(window: UIWindow) {
        self.window = window
        self.authRepository = FirebaseAuthRepository()
    }
    
    func start() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if hasSeenOnboarding {
            checkAuthAndShowAppropriateScreen()
        } else {
            showOnboarding()
        }
    }
    
    private func checkAuthAndShowAppropriateScreen() {
        if Auth.auth().currentUser != nil {
            showMainApp()
        } else {
            showAuth()
        }
    }
    
    func showOnboarding() {
        let viewModel = OnboardingViewModel()
        let onboardingVC = OnboardingViewController(viewModel: viewModel)
        onboardingVC.coordinator = self
        window.rootViewController = onboardingVC
        window.makeKeyAndVisible()
    }
    
    func showAuth() {
        let authCoordinator = AuthCoordinator(window: window)
        authCoordinator.delegate = self
        authCoordinator.start()
        self.authCoordinator = authCoordinator
    }
    
    func showMainApp() {
        if let firebaseUser = Auth.auth().currentUser {
            guard let firebaseAuthRepo = authRepository as? FirebaseAuthRepository else {
                createMainCoordinator(with: nil)
                return
            }
            
            firebaseAuthRepo.fetchUser(userId: firebaseUser.uid) { result in                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        self.createMainCoordinator(with: user)
                    case .failure(let error):
                        print("Failed to fetch user: \(error.localizedDescription)")
                        self.createMainCoordinator(with: nil)
                    }
                }
            }
        } else {
            createMainCoordinator(with: nil)
        }
    }

    private func createMainCoordinator(with user: User?) {
        let mainCoordinator = MainCoordinator(window: window, currentUser: user)
        mainCoordinator.delegate = self
        mainCoordinator.start()
        self.mainCoordinator = mainCoordinator
    }
    
    func onboardingDidFinish() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        checkAuthAndShowAppropriateScreen()
    }
}

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
