import UIKit
import SwiftUI

protocol MainCoordinatorDelegate: AnyObject {
    func mainCoordinatorDidLogout(_ coordinator: MainCoordinator)
}

class MainCoordinator {
    private let window: UIWindow
    private var tabBarController: UITabBarController?
    weak var delegate: MainCoordinatorDelegate?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "mapIcon"), tag: 0)
        let mapNav = UINavigationController(rootViewController: mapVC)
        
        let chatView = ChatView(coordinator: self)
        let chatVC = UIHostingController(rootView: chatView)
        chatVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "chatIcon"), tag: 1)
        let chatNav = UINavigationController(rootViewController: chatVC)
        
        let homeVC = HomeViewController()
        homeVC.coordinator = self
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "homeIcon"), tag: 2)
        let homeNav = UINavigationController(rootViewController: homeVC)
        
        let profileView = ProfileView(coordinator: self)
        let profileVC = UIHostingController(rootView: profileView)
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "profileIcon"), tag: 3)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        let settingsView = SettingsView(coordinator: self)
        let settingsVC = UIHostingController(rootView: settingsView)
        settingsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "settingsIcon"), tag: 4)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        
        tabBarController.viewControllers = [homeNav, mapNav, chatNav, profileNav, settingsNav]
        
        self.tabBarController = tabBarController
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
//    func showDetails(for item: type) {
//        guard let tabBarController = tabBarController,
//              let homeNav = tabBarController.viewControllers?.first as? UINavigationController else {
//            return
//        }
//        
//        let detailsView = DetailsView(item: item, coordinator: self)
//        let detailsVC = UIHostingController(rootView: detailsView)
//        homeNav.pushViewController(detailsVC, animated: true)
//    }
  
    func logout() {
        delegate?.mainCoordinatorDidLogout(self)
    }
}
