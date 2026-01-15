import SwiftUI

class DIContainer {
    static let shared = DIContainer()
    
    private let authRepository: AuthRepository
    
    private init() {
        self.authRepository = FirebaseAuthRepository()
    }
    
    func makeChatViewModel() -> ChatViewModel {
        let repository = FirebaseChatRepository()
        let sendMessageUseCase = SendMessageUseCase(repository: repository)
        let resetChatUseCase = ResetChatUseCase(repository: repository)
                
        return ChatViewModel(
            sendMessageUseCase: sendMessageUseCase,
            resetChatUseCase: resetChatUseCase
        )
    }
    
    func makeProfileViewModel(user: User?, coordinator: MainCoordinator) -> ProfileViewModel {
        let userRepository = UserRepository()
        let getFavoriteUseCase = GetFavoritesUseCase(userRepositoryProtocol: userRepository)
        let logoutUseCase = LogoutUseCase(authRepository: authRepository)
        
        return ProfileViewModel(
            profile: user,
            getFavoriteUseCase: getFavoriteUseCase,
            logoutUseCase: logoutUseCase,
            coordinator: coordinator
        )
    }
}
