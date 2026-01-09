class HomeViewModel {
    private let repository: ReptileRepositoryProtocol
    
    var reptiles: [Reptile] = []
    var errorMsg: String?
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(repository: ReptileRepositoryProtocol = ReptileRepository()) {
        self.repository = repository
    }
    
    func loadReptiles() {
        Task {
            do {
                let fetchedReptiles = try await repository.fetchAllReptiles()
                
                await MainActor.run {
                    self.reptiles = fetchedReptiles
                    self.onDataUpdated?()
                }
            } catch {
                await MainActor.run {
                    self.errorMsg = error.localizedDescription
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}

