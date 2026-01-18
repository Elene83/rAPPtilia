import UIKit

protocol AddLocationUseCaseProtocol {
    func execute(userId: String, location: LocationModel, completion: @escaping (Result<Void, Error>) -> Void)
}

class AddLocationUseCase: AddLocationUseCaseProtocol {
    private let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: String, location: LocationModel, completion: @escaping (Result<Void, any Error>) -> Void) {
        repository.addLocation(userId: userId, location: location, completion: completion)
    }
}

protocol RemoveLocationUseCaseProtocol {
    func execute(userId: String, locationId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class RemoveLocationUseCase: RemoveLocationUseCaseProtocol {
    private let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: String, locationId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        repository.removeLocation(userId: userId, locationId: locationId, completion: completion)
    }
}

protocol GetUserLocationsUseCaseProtocol {
    func execute(userId: String, completion: @escaping (Result<[LocationModel], Error>) -> Void)
}

class GetUserLocationsUseCase: GetUserLocationsUseCaseProtocol {
    private let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: String, completion: @escaping (Result<[LocationModel], Error>) -> Void) {
        repository.getLocations(userId: userId, completion: completion)
    }
}


protocol GetAllLocationsUseCaseProtocol {
    func execute(userId: String, completion: @escaping (Result<[LocationModel], Error>) -> Void)
}

class GetAllLocationsUseCase: GetAllLocationsUseCaseProtocol {
    private let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(userId: String, completion: @escaping (Result<[LocationModel], any Error>) -> Void) {
        repository.getAllLocations(userId: userId, completion: completion)
    }
}
