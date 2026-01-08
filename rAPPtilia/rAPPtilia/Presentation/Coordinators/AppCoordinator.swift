import UIKit

class AppCoordinator {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if hasSeenOnboarding {
            showHome()
        } else {
            showOnboarding()
        }
    }
    
    func showOnboarding() {
        let viewModel = OnboardingViewModel()
        let onboardingVC = OnboardingViewController(viewModel: viewModel)
        onboardingVC.coordinator = self
        window.rootViewController = onboardingVC
        window.makeKeyAndVisible()
    }
    
    func showHome() {
        let homeVC = HomeViewController()
        window.rootViewController = homeVC
        window.makeKeyAndVisible()
    }
    
    func onboardingDidFinish() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        showHome()
    }
}
