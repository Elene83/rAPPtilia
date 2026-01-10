protocol FetchAllReptilesUseCaseProtocol {
    func execute(filters: ReptileFilters?) async throws -> [Reptile]
}

struct ReptileFilters {
    var venomous: Bool?
    var color: String?
    var diet: String?
    var activityPeriod: String?
    var temperament: String?
    var headshape: String?
    var size: String?
}

#warning("finish this up")
