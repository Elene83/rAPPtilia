import Foundation

struct ReptileDTO: Codable {
    let about: String
    let activityPeriod: String
    let color: [String]
    let commonName: String
    let diet: String
    let habitat: String
    let headShape: String
    let images: [String]
    let lifespan: String
    let name: String
    let sizeRange: String
    let temperament: String
    let thumbnailUrl: String
    let venom: Bool
    
    enum CodingKeys: String, CodingKey {
        case about
        case activityPeriod = "activity_period"
        case color
        case commonName = "common_name"
        case diet
        case habitat
        case headShape = "head_shape"
        case images
        case lifespan
        case name
        case sizeRange = "size_range"
        case temperament
        case thumbnailUrl = "thumbnail_url"
        case venom
    }
    
    func toDomain(id: String) -> Reptile {
        Reptile(
            id: id,
            about: about,
            activityPeriod: activityPeriod,
            color: color,
            commonName: commonName,
            diet: diet,
            habitat: habitat,
            headShape: headShape,
            images: images,
            lifespan: lifespan,
            name: name,
            sizeRange: sizeRange,
            temperament: temperament,
            thumbnailUrl: thumbnailUrl,
            venom: venom
        )
    }
}
