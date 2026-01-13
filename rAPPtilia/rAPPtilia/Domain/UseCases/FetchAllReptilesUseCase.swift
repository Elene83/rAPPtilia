protocol FetchAllReptilesUseCaseProtocol {
    func execute(filters: ReptileFilters?) async throws -> [Reptile]
}

class FetchAllReptilesUseCase: FetchAllReptilesUseCaseProtocol {
    private let repository: ReptileRepositoryProtocol
    
    init(repository: ReptileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(filters: ReptileFilters?) async throws -> [Reptile] {
        let allReptiles = try await repository.fetchAllReptiles()
        
        guard let filters = filters else {
            return allReptiles
        }
        
        var filtered = allReptiles
        
        if let order = filters.order {
            filtered = filtered.filter { $0.order.lowercased() == order.lowercased() }
        }
        
        if let venomous = filters.venomous {
            filtered = filtered.filter { $0.venom == venomous }
        }
        
        if let color = filters.color {
            filtered = filtered.filter { reptile in
                reptile.color.contains(where: { $0.lowercased().contains(color.lowercased()) })
            }
        }
        
        if let headshape = filters.headshape {
            filtered = filtered.filter { $0.headShape.lowercased() == headshape.lowercased() }
        }
        
        if let activityPeriod = filters.activityPeriod {
            filtered = filtered.filter { $0.activityPeriod.lowercased() == activityPeriod.lowercased() }
        }
        
        if let temperament = filters.temperament {
            filtered = filtered.filter { $0.temperament.lowercased().contains(temperament.lowercased()) }
        }
        
        return filtered
    }
}

struct ReptileFilters {
    var order: String?
    var venomous: Bool?
    var color: String?
    var activityPeriod: String?
    var temperament: String?
    var headshape: String?
}
