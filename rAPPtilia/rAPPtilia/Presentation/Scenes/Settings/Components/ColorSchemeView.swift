import SwiftUI

struct ColorSchemeView: View {
    @ObservedObject var themeManager = ThemeManager.shared
    let onThemeChange: (ThemeManager.ThemeOption) -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("Change theme")
                .font(.custom("Firago-Regular", size: 18))
                .foregroundStyle(Color("AppDarkGreen"))
                .padding(.vertical, 10)
            HStack(spacing: 10) {
                ColorSchemeButton(
                    title: "Light",
                    option: .light,
                    isSelected: themeManager.themeOption == .light,
                    action: { onThemeChange(.light) }
                )
                
                ColorSchemeButton(
                    title: "Dark",
                    option: .dark,
                    isSelected: themeManager.themeOption == .dark,
                    action: { onThemeChange(.dark) }
                )
                
                ColorSchemeButton(
                    title: "System",
                    option: .system,
                    isSelected: themeManager.themeOption == .system,
                    action: { onThemeChange(.system) }
                )
            }
        }
    }
}

struct ColorSchemeButton: View {
    let title: String
    let option: ThemeManager.ThemeOption
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(title) {
            action()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 8)
        .background(isSelected ? Color("AppOrange") : Color("AppDarkGreen").opacity(0.1))
        .foregroundStyle(isSelected ? Color("AppStaticBG") : Color("AppDarkGreen"))
        .font(.custom("Firago-Regular", size: 16))
        .cornerRadius(4)
        .frame(maxWidth: .infinity)
    }
}
