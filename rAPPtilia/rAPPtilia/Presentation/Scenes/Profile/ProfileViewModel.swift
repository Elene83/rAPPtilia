import SwiftUI
import CoreLocation

final class ProfileViewModel: ObservableObject {
    //MARK: Properties
    @Published var profile: User?
    @Published var userReptiles: [Reptile] = []
    @Published var userLocations: [LocationModel] = []
    @Published var isLoadingReptiles = false
    @Published var isLoadingLocations = false
    @Published var isUpdatingProfile = false
    @Published var errorMessage: String?
    
    var isLoggedIn: Bool {
        profile != nil
    }

    private let getFavoriteUseCase: GetFavoritesUseCase
    private var removeFavoriteUseCase: RemoveFavoriteUseCase
    private let reptilesByIds: GetReptilesByIdsUseCase
    private let logoutUseCase: LogoutUseCase
    private let getUserLocationsUseCase: GetUserLocationsUseCaseProtocol
    private let removeLocationUseCase: RemoveLocationUseCaseProtocol
    
    private let updateFullNameUseCase: UpdateFullNameUseCase
    private let updateUsernameUseCase: UpdateUsernameUseCase
    
    let coordinator: MainCoordinator
    
    private let geocoder = CLGeocoder()
    @Published var addresses: [String: String] = [:]

    //MARK: Inits
    init(
        profile: User? = nil,
        isLoadingReptiles: Bool = false,
        getFavoriteUseCase: GetFavoritesUseCase,
        removeFavofiteUseCase: RemoveFavoriteUseCase,
        reptilesByIds: GetReptilesByIdsUseCase,
        logoutUseCase: LogoutUseCase,
        getUserLocationsUseCase: GetUserLocationsUseCaseProtocol,
        removeLocationUseCase: RemoveLocationUseCaseProtocol,
        updateFullNameUseCase: UpdateFullNameUseCase,
        updateUsernameUseCase: UpdateUsernameUseCase,
        coordinator: MainCoordinator) {
            self.profile = profile
            self.isLoadingReptiles = isLoadingReptiles
            self.getFavoriteUseCase = getFavoriteUseCase
            self.removeFavoriteUseCase = removeFavofiteUseCase
            self.reptilesByIds = reptilesByIds
            self.logoutUseCase = logoutUseCase
            self.getUserLocationsUseCase = getUserLocationsUseCase
            self.removeLocationUseCase = removeLocationUseCase
            self.updateFullNameUseCase = updateFullNameUseCase
            self.updateUsernameUseCase = updateUsernameUseCase
            self.coordinator = coordinator
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoritesChange),
            name: .favoritesDidChange,
            object: nil
        )
            
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLocationsChange),
            name: .locationsDidChange,
            object: nil
        )
            
        if let userId = profile?.id {
            Task {
                await fetchUserReptiles(userId: userId)
                await fetchUserLocations(userId: userId)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Methods
    @objc private func handleFavoritesChange() {
        refreshFavorites()
    }
    
    @objc private func handleLocationsChange() {
        guard let userId = profile?.id else { return }
        
        Task {
            await fetchUserLocations(userId: userId)
        }
    }
    
    func refreshFavorites() {
        guard let userId = profile?.id else { return }
           
        Task {
            await fetchUserReptiles(userId: userId)
        }
    }
    
    @MainActor
    private func fetchUserReptiles(userId: String) async {
        isLoadingReptiles = true
        
        getFavoriteUseCase.execute(userId: userId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let reptileIds):
                guard !reptileIds.isEmpty else {
                    Task { @MainActor in
                        self.isLoadingReptiles = false
                        self.userReptiles = []
                    }
                    return
                }
                
                Task {
                    do {
                        let reptiles = try await self.reptilesByIds.execute(ids: reptileIds)
                        await MainActor.run {
                            self.userReptiles = reptiles
                            self.isLoadingReptiles = false
                        }
                    } catch {
                        print("couldnt fetch reptiles: \(error)")
                        await MainActor.run {
                            self.userReptiles = []
                            self.isLoadingReptiles = false
                        }
                    }
                }
                
            case .failure(let error):
                Task { @MainActor in
                    self.isLoadingReptiles = false
                    print("coudlnt fetch favorites: \(error)")
                }
            }
        }
    }
    
    @MainActor
    private func fetchUserLocations(userId: String) async {
        isLoadingLocations = true
        
        getUserLocationsUseCase.execute(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingLocations = false
                
                switch result {
                case .success(let locations):
                    self?.userLocations = locations
                    locations.forEach { location in
                        self?.fetchAddress(for: location)
                    }
                case .failure(let error):
                    print("couldn't fetch locations: \(error)")
                    self?.userLocations = []
                }
            }
        }
    }
    
    private func fetchAddress(for location: LocationModel) {
            let coordinate = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            geocoder.reverseGeocodeLocation(coordinate) { [weak self] placemarks, error in
                guard let placemark = placemarks?.first else {
                    DispatchQueue.main.async {
                        self?.addresses[location.id] = "Unknown Location"
                    }
                    return
                }
                
                var addressParts: [String] = []
                
                if let street = placemark.thoroughfare {
                    addressParts.append(street)
                }
                if let city = placemark.locality {
                    addressParts.append(city)
                }
                if let country = placemark.country {
                    addressParts.append(country)
                }
                
                let address = addressParts.isEmpty ? "Unknown Location" : addressParts.joined(separator: ", ")
                
                DispatchQueue.main.async {
                    self?.addresses[location.id] = address
                }
            }
        }
    
    func getLocationAddress(for location: LocationModel) -> String {
        addresses[location.id] ?? "\(String(format: "%.4f", location.latitude)), \(String(format: "%.4f", location.longitude))"
    }
    
    func removeFavorite(reptileId: String) {
        guard let userId = profile?.id else { return }
        
        removeFavoriteUseCase.execute(userId: userId, reptileId: reptileId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
                case .failure(let error) :
                    print("couldn't remove favorite: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func removeLocation(locationId: String) {
        guard let userId = profile?.id else { return }
        
        removeLocationUseCase.execute(userId: userId, locationId: locationId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.userLocations.removeAll { $0.id == locationId }
                case .failure(let error):
                    print("couldn't remove location: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func logOut() {
        logoutUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.coordinator.logout()
                case .failure(let error):
                    print("couldnt log out \(error.localizedDescription)")
                    self?.coordinator.logout()
                }
            }
            
        }
    }
    
    func showAuth() {
        coordinator.logout()
    }
    
    func updateFullName(_ fullName: String) {
        guard let userId = profile?.id, !fullName.isEmpty else { return }
        
        isUpdatingProfile = true
        
        updateFullNameUseCase.execute(userId: userId, fullName: fullName) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUpdatingProfile = false
                
                switch result {
                case .success:
                    self?.profile = User(
                        id: userId,
                        fullName: fullName,
                        username: self?.profile?.username ?? "",
                        email: self?.profile?.email ?? "",
                        imageUrl: self?.profile?.imageUrl ?? "",
                        reptiles: self?.profile?.reptiles ?? [],
                        locations: self?.profile?.locations ?? [])
                case .failure(let error):
                    self?.errorMessage = "failed to update name \(error.localizedDescription)"
                }
            }
            
        }
    }
    
    func updateUsername(_ userName: String) {
        guard let userId = profile?.id, !userName.isEmpty else { return }
        
        isUpdatingProfile = true
        
        updateUsernameUseCase.execute(userId: userId, username: userName) { [weak self] result in
            DispatchQueue.main.async {
                self?.isUpdatingProfile = false
                
                switch result {
                case .success:
                    self?.profile = User(
                        id: userId,
                        fullName: self?.profile?.fullName ?? "",
                        username: userName,
                        email: self?.profile?.email ?? "",
                        imageUrl: self?.profile?.imageUrl ?? "",
                        reptiles: self?.profile?.reptiles ?? [],
                        locations: self?.profile?.locations ?? []
                    )
                case .failure(let error):
                    self?.errorMessage = "failed to update name \(error.localizedDescription)"
                }
            }
        }
    }
}
