import Foundation

extension UserDefaults {
    private enum Keys {
        static let isOtherViewEnabled = "isOtherViewEnabled"
    }
    
    var isOtherViewEnabled: Bool {
        get { bool(forKey: Keys.isOtherViewEnabled) }
        set { set(newValue, forKey: Keys.isOtherViewEnabled) }
    }
}
