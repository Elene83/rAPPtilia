protocol ResetChatUseCaseProtol {
    func execute() -> [ChatMessage]
}

class ResetChatUseCase: ResetChatUseCaseProtol {
    private let repository: FirebaseChatRepository
    
    init(repository: FirebaseChatRepository) {
        self.repository = repository
    }
    
    func execute() -> [ChatMessage] {
        return repository.initializeChat()
    }
}
