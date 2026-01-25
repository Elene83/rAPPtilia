import SwiftUI
import MapKit
import CoreLocation

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locations: [LocationModel] = []
    @Published var filteredLocations: [LocationModel] = []
    @Published var allReptiles: [Reptile] = []
    @Published var selectedOrderFilter: String?
    @Published var selectedSpeciesFilter: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingImagePreview = false
    @Published var previewImageUrl: String?
    
    @Published var isAddingLocation = false
    @Published var currentStep: AddLocationStep = .selectOrder
    @Published var selectedOrder: String?
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var selectedReptileForNewLocation: Reptile?
    
    @Published var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    @Published var userLocation: CLLocationCoordinate2D?
    
    private let locationManager = CLLocationManager()
    private var hasSetInitialCamera = false
    
    var profile: User?
    
    var coordinator: MainCoordinator?
    
    var isLoggedIn: Bool {
        profile != nil
    }
    
    func showImagePreview(_ url: String) {
        previewImageUrl = url
        showingImagePreview = true
    }
    
    enum AddLocationStep {
        case selectOrder
        case markLocation
        case selectSpecies
    }
    
    var filteredReptilesByOrder: [Reptile] {
        guard let order = selectedOrder else { return [] }
        return allReptiles.filter { $0.order.lowercased() == order.lowercased() }
    }
    
    var availableOrders: [String] {
        let orders = Set(allReptiles.map { $0.order })
        return Array(orders).sorted()
    }
    
    var availableSpecies: [String] {
        var reptilesToFilter = allReptiles
        
        if let orderFilter = selectedOrderFilter {
            reptilesToFilter = allReptiles.filter { $0.order.lowercased() == orderFilter.lowercased() }
        }
        
        let species = Set(reptilesToFilter.map { $0.commonName })
        return Array(species).sorted()
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
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
            
            if !self.hasSetInitialCamera {
                self.hasSetInitialCamera = true
                self.cameraPosition = .region(MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            DispatchQueue.main.async {
                self.errorMessage = "Location access is required to show your position on the map. Please enable it in Settings."
            }
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                print("trying to find the location")
                return
                
            case .denied:
                DispatchQueue.main.async {
                    self.errorMessage = "Location access denied. Please enable it in Settings."
                }
                
            case .network:
                DispatchQueue.main.async {
                    self.errorMessage = "Network error while getting location. Please check your connection."
                }
                
            default:
                DispatchQueue.main.async {
                    self.errorMessage = "Location error: \(error.localizedDescription)"
                }
            }
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "Location error: \(error.localizedDescription)"
            }
        }
    }
    
    func loadData() {
        Task {
            await loadReptiles()
            await loadLocations()
        }
    }
    
    @MainActor
    private func loadReptiles() async {
        do {
            allReptiles = try await fetchAllReptilesUseCase.execute(filters: nil)
        } catch {
            errorMessage = "Failed to load reptiles: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func loadLocations() async {
        isLoading = true
        errorMessage = nil
        
        await withCheckedContinuation { continuation in
            getAllLocationsUseCase.execute { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    switch result {
                    case .success(let locations):
                        self?.locations = locations
                        self?.applyFilter()
                    case .failure(let error):
                        self?.errorMessage = "Failed to load locations: \(error.localizedDescription)"
                    }
                    continuation.resume()
                }
            }
        }
    }
    
    func seeDetails(for reptile: Reptile?, from navigationController: UINavigationController?) {
        guard let reptile = reptile else {
            return
        }
        guard let navigationController = navigationController else {
            return
        }
        coordinator?.showDetails(for: reptile, from: navigationController)
    }
    
    func applyFilter() {
        var filtered = locations
        
        if let orderFilter = selectedOrderFilter {
            filtered = filtered.filter { location in
                guard let reptile = allReptiles.first(where: { $0.id == location.reptileId }) else { return false }
                return reptile.order.lowercased() == orderFilter.lowercased()
            }
        }
        
        if let speciesFilter = selectedSpeciesFilter {
            filtered = filtered.filter { location in
                guard let reptile = allReptiles.first(where: { $0.id == location.reptileId }) else { return false }
                return reptile.commonName == speciesFilter
            }
        }
        
        filteredLocations = filtered
    }
    
    func setOrderFilter(_ order: String?) {
        selectedOrderFilter = order
        applyFilter()
    }
    
    func setSpeciesFilter(_ species: String?) {
        selectedSpeciesFilter = species
        applyFilter()
    }
    
    func clearAllFilters() {
        selectedOrderFilter = nil
        selectedSpeciesFilter = nil
        applyFilter()
    }
    
    func startAddingLocation() {
        guard isLoggedIn else {
            errorMessage = "You must be logged in to add locations"
            return
        }
        isAddingLocation = true
        currentStep = .selectOrder
    }
    
    func cancelAddingLocation() {
        isAddingLocation = false
        currentStep = .selectOrder
        selectedOrder = nil
        selectedCoordinate = nil
        selectedReptileForNewLocation = nil
    }
    
    func selectOrder(_ order: String) {
        selectedOrder = order
        currentStep = .markLocation
    }
    
    func handleMapTap(at coordinate: CLLocationCoordinate2D) {
        guard currentStep == .markLocation else { return }
        selectedCoordinate = coordinate
        currentStep = .selectSpecies
    }
    
    func selectSpecies(_ reptile: Reptile) {
        selectedReptileForNewLocation = reptile
        addLocation()
    }
    
    func goBackToSpeciesSelection() {
        currentStep = .selectSpecies
    }
    
    func addLocation() {
        guard let userId = profile?.id,
              let username = profile?.fullName,
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
            username: username,
            timeStamp: Date()
        )
        
        isLoading = true
        errorMessage = nil
        
        addLocationUseCase.execute(userId: userId, location: newLocation) { [weak self] result in
            Task { @MainActor in
                await self?.handleLocationOperationResult(
                    result: result,
                    shouldCancelAdding: true,
                    errorPrefix: "Failed to add location"
                )
            }
        }
    }
    
    func removeLocation(_ location: LocationModel) {
        guard let userId = profile?.id else { return }
        
        guard location.userId == userId else {
            errorMessage = "You can only delete your own locations"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        removeLocationUseCase.execute(userId: userId, locationId: location.id) { [weak self] result in
            Task { @MainActor in
                await self?.handleLocationOperationResult(
                    result: result,
                    shouldCancelAdding: false,
                    errorPrefix: "Failed to remove location"
                )
            }
        }
    }
    
    @MainActor
    private func handleLocationOperationResult(
        result: Result<Void, Error>,
        shouldCancelAdding: Bool,
        errorPrefix: String
    ) async {
        isLoading = false
        
        switch result {
        case .success:
            if shouldCancelAdding {
                cancelAddingLocation()
            }
            await loadLocations()
            NotificationCenter.default.post(name: .locationsDidChange, object: nil)
        case .failure(let error):
            errorMessage = "\(errorPrefix): \(error.localizedDescription)"
        }
    }
    
    func getReptile(for location: LocationModel) -> Reptile? {
        allReptiles.first { $0.id == location.reptileId }
    }
    
    func getObserver(for location: LocationModel) -> String {
        return location.userId
    }
}
