import SwiftUI
import UIKit

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    enum ThemeOption: String {
        case light, dark, system
    }
    
    @Published var selectedTheme: ColorScheme = .light
    @Published var themeOption: ThemeOption = .system
    
    private init() {
        loadThemePreference()
        applyTheme()
    }
    
    private func loadThemePreference() {
        if let savedOption = UserDefaults.standard.string(forKey: "colorScheme"),
           let option = ThemeOption(rawValue: savedOption) {
            themeOption = option
            
            switch option {
            case .light:
                selectedTheme = .light
            case .dark:
                selectedTheme = .dark
            case .system:
                selectedTheme = UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
            }
        }
    }
    
    func setColorScheme(_ scheme: ColorScheme) {
        selectedTheme = scheme
        themeOption = scheme == .dark ? .dark : .light
        UserDefaults.standard.set(themeOption.rawValue, forKey: "colorScheme")
        applyTheme()
    }
    
    func setSystemTheme() {
        themeOption = .system
        selectedTheme = UITraitCollection.current.userInterfaceStyle == .dark ? .dark : .light
        UserDefaults.standard.set(ThemeOption.system.rawValue, forKey: "colorScheme")
        applyTheme()
    }
    
    private func applyTheme() {
        DispatchQueue.main.async {
            let interfaceStyle: UIUserInterfaceStyle
            
            switch self.themeOption {
            case .light:
                interfaceStyle = .light
            case .dark:
                interfaceStyle = .dark
            case .system:
                interfaceStyle = .unspecified
            }
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = interfaceStyle
                }
            }
        }
    }
}
