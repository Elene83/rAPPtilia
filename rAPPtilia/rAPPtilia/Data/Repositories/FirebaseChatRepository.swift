import Foundation
import FirebaseAI

protocol ChatRepository {
    func sendMessage(_ text: String, chatHistory: [ChatMessage]) async throws -> String
    func initializeChat() -> [ChatMessage]
}

class FirebaseChatRepository: ChatRepository {
    private var model: GenerativeModel
    private var chat: Chat?
    
    init() {
        let ai = FirebaseAI.firebaseAI(backend: .vertexAI())
        let config = GenerationConfig(
            temperature: 0.7,
            maxOutputTokens: 900,
            thinkingConfig: ThinkingConfig(thinkingBudget: 300)
        )
        self.model = ai.generativeModel(modelName: "gemini-2.5-flash", generationConfig: config)
        setupChat()
    }
    
    private func setupChat() {
        chat = model.startChat(history: [
            ModelContent(role: "user", parts: "You are a helpful assistant specializing in reptiles like turtles, snakes and lizards, as well as wildlife safety in Georgia, the country in the Caucasus region. Provide accurate, helpful information about reptile identification, safety, and handling. Keep responses concise and under 3-4 sentences unless asked for more detail."),
            ModelContent(role: "model", parts: "I understand. I'm here to help with reptile-related questions, particularly about lizards, snakes and turtles in Georgia, the country in the Caucasus region. I'll provide accurate, concise safety information and guidance.")
        ])
    }
    
    func sendMessage(_ text: String, chatHistory: [ChatMessage]) async throws -> String {
        guard let response = try await chat?.sendMessage(text) else {
            throw ChatError.noResponse
        }
        
        guard let responseText = response.text else {
            throw ChatError.emptyResponse
        }
        
        return responseText
    }
    
    func initializeChat() -> [ChatMessage] {
        setupChat()
        return []
    }
}

enum ChatError: Error {
    case emptyMessage
    case noResponse
    case emptyResponse
}
