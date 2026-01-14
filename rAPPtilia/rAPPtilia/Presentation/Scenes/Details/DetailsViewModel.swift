import SwiftUI

final class DetailsViewModel: ObservableObject {
    @Published var reptile: Reptile
    
    init(reptile: Reptile) {
        self.reptile = reptile
    }
    
    var descriptionItems: [DescriptionItem] {
        [
            .init(label: "Size", value: reptile.sizeRange),
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
}
