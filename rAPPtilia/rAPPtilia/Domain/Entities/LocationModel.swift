import UIKit
import CoreLocation

struct LocationModel: Identifiable, Codable, Hashable {
    var id: String
    let latitude: Double
    let longitude: Double
    let reptileId: String
    let userId: String
    let username: String
    let timeStamp: Date
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case latitude
        case longitude
        case reptileId
        case userId
        case username
        case timeStamp
    }
}
