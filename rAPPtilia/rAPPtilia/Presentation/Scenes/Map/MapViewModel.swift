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
    
    func handleMapTap(coordinate: CLLocationCoordinate2D) {
        guard isLoggedIn else {
            errorMessage = "Please log in to add a new location."
            return
        }
    
        selectedCoordinate = coordinate
        showingAddLocation = true
    }
    
    func addLocation() {
        guard let userId = profile?.id,
              let coordinate = selectedCoordinate,
              let reptile = selectedReptileForNewLocation else {
            return
        }
        
        let newLocation = LocationModel(
            id: UUID().uuidString,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            reptileId: reptile.id,
            userId: userId,
            timeStamp: Date()
        )
        
        isLoading = true
        errorMessage = nil
        
        addLocationUseCase.execute(userId: userId, location: newLocation) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.showingAddLocation = false
                    self?.selectedCoordinate = nil
                    self?.selectedReptileForNewLocation = nil
                    self?.loadLocations()
                case .failure(let error):
                    self?.errorMessage = "couldnt add location \(error.localizedDescription)"
                }
            }
        }
    }
    
    func removeLocation(_ location: LocationModel) {
        guard let userId = profile?.id else { return }
        
        guard location.userId == userId else {
            errorMessage = "you can only delete your own locations goof"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        removeLocationUseCase.execute(userId: userId, locationId: location.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.loadLocations()
                case .failure(let error):
                    self?.errorMessage = "couldnt remove location \(error.localizedDescription)"
                }
            }
        }
    }
    
    func getReptile(for location: LocationModel) -> Reptile? {
        allReptiles.first { $0.id == location.reptileId }
    }
    
    func cancelAddingLocation() {
        showingAddLocation = false
        selectedCoordinate = nil
        selectedReptileForNewLocation = nil
    }
}
