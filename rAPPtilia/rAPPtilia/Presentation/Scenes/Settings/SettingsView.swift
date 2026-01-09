import SwiftUI

struct SettingsView: View {
    let coordinator: MainCoordinator
    
    var body: some View {
        VStack {
            Text("Settings")
            
            Button("Logout") {
                coordinator.logout()
            }
        }
        .navigationTitle("Settings")
    }
}
