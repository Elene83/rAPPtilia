import SwiftUI

class DIContainer {
    static let shared = DIContainer()
    
    private let authRepository: AuthRepository
    private let reptileRepository: ReptileRepositoryProtocol

    private init() {
        self.authRepository = FirebaseAuthRepository()
        self.reptileRepository = ReptileRepository()
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
        let removeFavoriteUseCase = RemoveFavoriteUseCase(userRepositoryProtocol: userRepository)
        let getReptilesByIdsUseCase = GetReptilesByIdsUseCase(repository: reptileRepository)
        let logoutUseCase = LogoutUseCase(authRepository: authRepository)
        let updateFullNameUseCase = UpdateFullNameUseCase(userRepository: userRepository)
        let updateUsernameUseCase = UpdateUsernameUseCase(userRepository: userRepository)

         
         return ProfileViewModel(
             profile: user,
             getFavoriteUseCase: getFavoriteUseCase,
             removeFavofiteUseCase: removeFavoriteUseCase,
             reptilesByIds: getReptilesByIdsUseCase,
             logoutUseCase: logoutUseCase,
             updateFullNameUseCase: updateFullNameUseCase,
             updateUsernameUseCase: updateUsernameUseCase,
             coordinator: coordinator
         )
     }
    
    func makeSettingsViewModel(user: User?, coordinator: MainCoordinator) -> SettingsViewModel {
        return SettingsViewModel(
            profile: user,
            changePasswordUseCase: ChangePasswordUseCase(authRepository: authRepository),
            deleteAccountUseCase: DeleteAccountUseCase(authRepository: authRepository),
            coordinator: coordinator
        )
    }
 }
