import SwiftUI
import MapKit

final class MapViewModel: ObservableObject {
    @Published var locations: [LocationModel] = []
    @Published var filteredLocations: [LocationModel] = []
    @Published var allReptiles: [Reptile] = []
    @Published var selectedReptileFilter: Reptile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingAddLocation = false
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var selectedReptileForNewLocation: Reptile?
    
    @Published var cameraPosition: MapCameraPosition = .automatic
    
    var profile: User?
    
    var isLoggedIn: Bool {
        profile != nil
    }
    
    private let getAllLocationsUseCase: GetAllLocationsUseCaseProtocol
    private let addLocationUseCase: AddLocationUseCaseProtocol
    private let removeLocationUseCase: RemoveLocationUseCaseProtocol
    private let fetchAllReptilesUseCase: FetchAllReptilesUseCaseProtocol
    
    init(
        profile: User?,
        getAllLocationsUseCase: GetAllLocationsUseCaseProtocol,
        addLocationUseCase: AddLocationUseCaseProtocol,
        removeLocationUseCase: RemoveLocationUseCaseProtocol,
        fetchAllReptilesUseCase: FetchAllReptilesUseCaseProtocol
    ) {
        self.profile = profile
        self.getAllLocationsUseCase = getAllLocationsUseCase
        self.addLocationUseCase = addLocationUseCase
        self.removeLocationUseCase = removeLocationUseCase
        self.fetchAllReptilesUseCase = fetchAllReptilesUseCase
    }
    
    func loadData() {
        Task {
            await loadReptiles()
            loadLocations()
        }
    }
    
    @MainActor
    private func loadReptiles() async {
        do {
            allReptiles = try await fetchAllReptilesUseCase.execute(filters: nil)
        } catch {
            errorMessage = "failed to fetch reptiles \(error.localizedDescription)"
        }
    }
    
    func loadLocations() {
        isLoading = true
        errorMessage = nil
        
        getAllLocationsUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let locations):
                    self?.locations = locations
                    self?.applyFilter()
                case .failure(let error):
                    self?.errorMessage = "couldnt get locations \(error.localizedDescription)"
                }
            }
        }
    }
    
    func applyFilter() {
        if let filter = selectedReptileFilter {
            filteredLocations = locations.filter { $0.reptileId == filter.id }
           } else {
            filteredLocations = locations
        }
    }
    
    func setFilter(_ reptile: Reptile?) {
        selectedReptileFilter = reptile
        applyFilter()
    }
       
    func clearFilter() {
        selectedReptileFilter = nil
        applyFilter()
    }
}
