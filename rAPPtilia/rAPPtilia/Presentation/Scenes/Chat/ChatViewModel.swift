import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var currentInput: String = ""
    @Published var isLoading: Bool = false
    @Published var isTapped = false
    
    private let sendMessageUseCase: SendMessageUseCase
    private let resetChatUseCase: ResetChatUseCase
    
    init(
        sendMessageUseCase: SendMessageUseCase,
        resetChatUseCase: ResetChatUseCase
    ) {
        self.sendMessageUseCase = sendMessageUseCase
        self.resetChatUseCase = resetChatUseCase
    }
    
    func sendMessage(_ text: String) async {
        let userMessage = ChatMessage(text: text, isUser: true)
            
        await MainActor.run {
            messages.append(userMessage)
            currentInput = ""
            isLoading = true
        }
            
        do {
            let responseText = try await sendMessageUseCase.execute(text, chatHistory: messages)
            let aiMessage = ChatMessage(text: responseText, isUser: false)
                    
            await MainActor.run {
                messages.append(aiMessage)
                isLoading = false
            }
        } catch {
            await MainActor.run {
                let errorMessage = ChatMessage(text: "Sorry, something went wrong :( try again. 🐢", isUser: false)
                messages.append(errorMessage)
                isLoading = false
            }
            print("Error sending message: \(error)")
        }
    }
    
    func startConvo(with prompt: String) async {
        await sendMessage(prompt)
    }
    
    func resetChat() {
        messages = resetChatUseCase.execute()
        currentInput = ""
        isLoading = false
    }
    
    func handleTap() {
        isTapped = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isTapped = false
        }
    }
}
