import SwiftUI

struct ProfileView: View {
    let coordinator: MainCoordinator
    
    var body: some View {
        VStack {
            Text("Profile")
            
            Button("Logout") {
                coordinator.logout()
            }
        }
        .navigationTitle("Profile")
    }
}
