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
//            showMainApp()
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
        let mainCoordinator = MainCoordinator(window: window)
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
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        showMainApp()
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorDidLogout(_ coordinator: MainCoordinator) {
        authRepository.logout { [weak self] result in
            switch result {
            case .success:
                self?.showAuth()
            case .failure(let error):
                print("Error signing out: \(error.localizedDescription)")
                self?.showAuth()
            }
        }
    }
}

//TODO: add validations ui
