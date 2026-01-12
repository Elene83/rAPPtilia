protocol SendMessageUseCaseProtocol {
    func execute(_ text: String, chatHistory: [ChatMessage]) async throws -> String
}

class SendMessageUseCase: SendMessageUseCaseProtocol {
    private let repository: FirebaseChatRepository
      
      init(repository: FirebaseChatRepository) {
          self.repository = repository
      }
      
      func execute(_ text: String, chatHistory: [ChatMessage]) async throws -> String {
          guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
              throw ChatError.emptyMessage
          }
          
          return try await repository.sendMessage(text, chatHistory: chatHistory)
      }
}

