class GetReptilesByIdsUseCase {
    private let repository: ReptileRepositoryProtocol
    
    init(repository: ReptileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(ids: [String]) async throws -> [Reptile] {
        var reptiles: [Reptile] = []
        
        for id in ids {
            do {
                let reptile = try await repository.fetchReptile(id: id)
                reptiles.append(reptile)
            } catch {
                print("couldnt fetch reptile with id \(id): \(error)")
            }
        }
        
        return reptiles
    }
}
