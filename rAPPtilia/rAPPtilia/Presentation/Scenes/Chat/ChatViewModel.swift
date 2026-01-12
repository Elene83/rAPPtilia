import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var isTapped = false
    
    func handleTap() {
        isTapped = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isTapped = false
        }
    }
}
