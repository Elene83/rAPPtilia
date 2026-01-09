import Foundation

protocol ReptileRepositoryProtocol {
    func fetchAllReptiles() async throws -> [Reptile]
    func fetchReptile(id: String) async throws -> Reptile
}

class ReptileRepository: ReptileRepositoryProtocol {
    private let networkService: NetworkService
    private let collection = "reptiles"
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }
    
    func fetchAllReptiles() async throws -> [Reptile] {
        let results: [(id: String, data: ReptileDTO)] = try await networkService.fetchCollection(collection)
        
        return results.map { result in
            result.data.toDomain(id: result.id)
        }
    }
    
    func fetchReptile(id: String) async throws -> Reptile {
        let dto: ReptileDTO = try await networkService.fetchDocument(collection, id: id)
        return dto.toDomain(id: id)
    }
}
