import SwiftUI

class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    func makeChatViewModel() -> ChatViewModel {
        let repository = FirebaseChatRepository()
        let sendMessageUseCase = SendMessageUseCase(repository: repository)
        let resetChatUseCase = ResetChatUseCase(repository: repository)
                
        return ChatViewModel(
            sendMessageUseCase: sendMessageUseCase,
            resetChatUseCase: resetChatUseCase
        )
    }
}
