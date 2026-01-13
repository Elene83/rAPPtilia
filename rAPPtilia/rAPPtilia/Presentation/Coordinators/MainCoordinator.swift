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
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithDefaultBackground()
        navAppearance.backgroundColor = UIColor(named: "AppBG")
        navAppearance.shadowColor = nil
        navAppearance.shadowImage = UIImage()
        navAppearance.titleTextAttributes = [
              .foregroundColor: UIColor(named: "AppDarkRed") ?? .red,
              .font: UIFont(name: "Firago-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        ]
        
        let greenNavAppearance = UINavigationBarAppearance()
        greenNavAppearance.configureWithDefaultBackground()
        greenNavAppearance.backgroundColor = UIColor(named: "AppBG")
        greenNavAppearance.shadowColor = nil
        greenNavAppearance.shadowImage = UIImage()
            greenNavAppearance.titleTextAttributes = [
                .foregroundColor: UIColor(named: "AppDarkGreen") ?? .green,
                .font: UIFont(name: "Firago-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        ]

        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "mapIcon"), tag: 0)
        let mapNav = UINavigationController(rootViewController: mapVC)
        
        let chatView = ChatView(coordinator: self)
        let chatVC = UIHostingController(rootView: chatView)
        chatVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "chatIcon"), tag: 1)
        chatVC.navigationItem.title = "TurtleBot"
        let chatNav = UINavigationController(rootViewController: chatVC)
        chatNav.navigationBar.standardAppearance = navAppearance
        chatNav.navigationBar.scrollEdgeAppearance = navAppearance
            
        let homeVC = HomeViewController()
        homeVC.coordinator = self
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "homeIcon"), tag: 2)
        homeVC.navigationItem.title = "Home"
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.navigationBar.standardAppearance = navAppearance
        homeNav.navigationBar.scrollEdgeAppearance = navAppearance
        
        let profileView = ProfileView(coordinator: self)
        let profileVC = UIHostingController(rootView: profileView)
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profileIcon"), tag: 3)
        profileVC.navigationItem.title = "Profile"
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.navigationBar.standardAppearance = greenNavAppearance
        profileNav.navigationBar.scrollEdgeAppearance = greenNavAppearance
        
        let settingsView = SettingsView(coordinator: self)
        let settingsVC = UIHostingController(rootView: settingsView)
        settingsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "settingsIcon"), tag: 4)
        settingsVC.navigationItem.title = "Settings"
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.navigationBar.standardAppearance = greenNavAppearance
        settingsNav.navigationBar.scrollEdgeAppearance = greenNavAppearance
        
        tabBarController.viewControllers = [mapNav, chatNav, homeNav, profileNav, settingsNav]
        tabBarController.selectedIndex = 2

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
