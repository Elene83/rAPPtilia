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
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "AppTabBG")
        
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "AppOpaqueGreen")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "AppOpaqueGreen") ?? .gray]
            
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "AppDarkGreen")
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "AppDarkGreen") ?? .gray]
        
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
               tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        
        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "mapIcon"), tag: 0)
        let mapNav = UINavigationController(rootViewController: mapVC)
        
        let chatView = ChatView(coordinator: self)
        let chatVC = UIHostingController(rootView: chatView)
        chatVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "chatIcon"), tag: 1)
        let chatNav = UINavigationController(rootViewController: chatVC)
        
        let homeVC = HomeViewController()
        homeVC.coordinator = self
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "homeIcon"), tag: 2)
        let homeNav = UINavigationController(rootViewController: homeVC)
        
        let profileView = ProfileView(coordinator: self)
        let profileVC = UIHostingController(rootView: profileView)
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profileIcon"), tag: 3)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        let settingsView = SettingsView(coordinator: self)
        let settingsVC = UIHostingController(rootView: settingsView)
        settingsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "settingsIcon"), tag: 4)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        
        tabBarController.viewControllers = [mapNav, chatNav, homeNav, profileNav, settingsNav]

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
