class AddFavoriteUseCase {
    private let userRepositoryProtocol: UserRepositoryProtocol
    
    init(userRepositoryProtocol: UserRepositoryProtocol) {
        self.userRepositoryProtocol = userRepositoryProtocol
    }
    
    func execute(userId: String, reptileId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepositoryProtocol.addFavorite(userId: userId, reptileId: reptileId, completion: completion)
    }
}

class RemoveFavoriteUseCase {
    private let userRepositoryProtocol: UserRepositoryProtocol
    
    init(userRepositoryProtocol: UserRepositoryProtocol) {
        self.userRepositoryProtocol = userRepositoryProtocol
    }
    
    func execute(userId: String, reptileId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        userRepositoryProtocol.removeFavorite(userId: userId, reptileId: reptileId, completion: completion)
    }
}

class GetFavoritesUseCase {
    private let userRepositoryProtocol: UserRepositoryProtocol
    
    init(userRepositoryProtocol: UserRepositoryProtocol) {
        self.userRepositoryProtocol = userRepositoryProtocol
    }
    
    func execute(userId: String, completion: @escaping (Result<[String], Error>) -> Void) {
        userRepositoryProtocol.getFavorites(userId: userId, completion: completion)
    }
}
