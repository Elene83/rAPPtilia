import SwiftUI

class HomeViewModel: ObservableObject {
    //MARK: Properties
    private let useCase: FetchAllReptilesUseCaseProtocol
    
    @Published var reptiles: [Reptile] = []
    @Published var allReptiles: [Reptile] = []
    @Published var filters = ReptileFilters()

    var errorMsg: String?
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    //MARK: Inits
    init(useCase: FetchAllReptilesUseCaseProtocol = FetchAllReptilesUseCase(repository: ReptileRepository())) {
          self.useCase = useCase
    }
    
    //MARK: Methods
    func loadReptiles() {
        Task {
            do {
                let fetchedReptiles = try await useCase.execute(filters: nil)
                
                await MainActor.run {
                    self.allReptiles = fetchedReptiles
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
    
    func applyFilters() {
        Task {
            do {
                let filteredReptiles = try await useCase.execute(filters: filters)
                
                await MainActor.run {
                    self.reptiles = filteredReptiles
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
