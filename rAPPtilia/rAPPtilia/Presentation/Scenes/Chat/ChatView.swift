import SwiftUI

struct ChatView: View {
    let coordinator: MainCoordinator
    
    var body: some View {
        VStack {
            Text("Chat")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBG"))
        .navigationTitle("TurtleBot")
    }
}
