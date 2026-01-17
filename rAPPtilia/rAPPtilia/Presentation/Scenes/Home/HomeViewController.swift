import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    private let vm = HomeViewModel()
    weak var coordinator: MainCoordinator?
    
    private let toggle = UISwitch()
    private var currentHostingController: UIHostingController<HomeView>?
    private var cardsHostingController: UIHostingController<HomeCards>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppBG")
        setupToggle()
        
        toggle.isOn = UserDefaults.standard.isOtherViewEnabled
        
        vm.onDataUpdated = { [weak self] in
            guard let self = self else { return }
        }
                
        vm.loadReptiles()
        updateViewForToggleState()
    }
    
    private func setupToggle() {
        view.addSubview(toggle)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(toggleDidChange), for: .valueChanged)
        
        toggle.onTintColor = UIColor(named: "AppDarkRed")
        toggle.thumbTintColor = UIColor(named: "AppDarkRed")
        
        NSLayoutConstraint.activate([
            toggle.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),
            toggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    @objc private func toggleDidChange() {
        UserDefaults.standard.isOtherViewEnabled = toggle.isOn
        
        if toggle.isOn {
            hideHomeCards()
            showHome2()
            toggle.thumbTintColor = UIColor(named: "AppBG")
        } else {
            hideHome2()
            showHomeCards()
            toggle.thumbTintColor = UIColor(named: "AppDarkRed")
        }
    }
    
    private func showHome2() {
        let swiftUIView = HomeView(vm: vm, navigationController: navigationController)
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        currentHostingController = hostingController
        
        view.bringSubviewToFront(toggle)
    }
    
    private func showHomeCards() {
        let swiftUIView = HomeCards(
            vm: vm,
            coordinator: coordinator,
            navigationController: navigationController
        )
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        cardsHostingController = hostingController
        
        view.bringSubviewToFront(toggle)
    }
    
    private func updateViewForToggleState() {
        if toggle.isOn {
            showHome2()
            toggle.thumbTintColor = UIColor(named: "AppBG")
        } else {
            showHomeCards()
            toggle.thumbTintColor = UIColor(named: "AppDarkRed")
        }
    }
    
    private func hideHome2() {
        currentHostingController?.willMove(toParent: nil)
        currentHostingController?.view.removeFromSuperview()
        currentHostingController?.removeFromParent()
        currentHostingController = nil
    }
    
    private func hideHomeCards() {
        cardsHostingController?.willMove(toParent: nil)
        cardsHostingController?.view.removeFromSuperview()
        cardsHostingController?.removeFromParent()
        cardsHostingController = nil
    }
}
