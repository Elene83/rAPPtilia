import SwiftUI
import FirebaseAuth

final class DetailsViewModel: ObservableObject {
    @Published var reptile: Reptile
    @Published var isFavorite: Bool = false
    @Published var isLoading: Bool = false
    
    private let addFavoriteUseCase: AddFavoriteUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    private let getFavoriteUseCase: GetFavoritesUseCase
    
    init(reptile: Reptile, userRepository: UserRepositoryProtocol = UserRepository()
    ) {
        self.reptile = reptile
        self.addFavoriteUseCase = AddFavoriteUseCase(userRepositoryProtocol: userRepository)
        self.removeFavoriteUseCase = RemoveFavoriteUseCase(userRepositoryProtocol: userRepository)
        self.getFavoriteUseCase = GetFavoritesUseCase(userRepositoryProtocol: userRepository)
        
        checkIfFavorite()
    }
    
    var descriptionItems: [DescriptionItem] {
        [
            .init(label: "Size range", value: reptile.sizeRange),
            .init(label: "Head Shape", value: reptile.headShape),
            .init(label: "Activity", value: reptile.activityPeriod),
            .init(label: "Diet", value: reptile.diet),
            .init(label: "Venom", value: reptile.venom ? "Venomous" : "Non-venomous"),
            .init(label: "Lifespan", value: reptile.lifespan),
            .init(label: "Temperament", value: reptile.temperament),
            .init(label: "Habitat", value: reptile.habitat),
            .init(label: "Color", value: flattenedColors)
        ]
    }
    
    private var flattenedColors: String {
        guard !reptile.color.isEmpty else {return "-"}
        return reptile.color.joined(separator: ",")
    }
    
    func toggleFavorite() {
           guard let userId = Auth.auth().currentUser?.uid else {
               return
           }
           
           isLoading = true
           
           if isFavorite {
               removeFavoriteUseCase.execute(userId: userId, reptileId: reptile.id) { [weak self] result in
                   DispatchQueue.main.async {
                       self?.isLoading = false
                       switch result {
                       case .success:
                           self?.isFavorite = false
                       case .failure(let error):
                           print("ar gamevida \(error.localizedDescription)")
                       }
                   }
               }
           } else {
               addFavoriteUseCase.execute(userId: userId, reptileId: reptile.id) { [weak self] result in
                   DispatchQueue.main.async {
                       self?.isLoading = false
                       switch result {
                       case .success:
                           self?.isFavorite = true
                       case .failure(let error):
                           print((error.localizedDescription))
                       }
                   }
               }
           }
       }
    
    private func checkIfFavorite() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        getFavoriteUseCase.execute(userId: userId, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let favoriteIds):
                    self?.isFavorite = favoriteIds.contains(self?.reptile.id ?? "")
                case .failure(let error):
                    print("couldnt check \(error.localizedDescription)")
                }
            }
        })
    }
}
