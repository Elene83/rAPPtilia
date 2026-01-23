import SwiftUI

struct LocationAnnotationView: View {
    let reptile: Reptile
    let isUserLocation: Bool
    
    var markerIcon: String {
        switch reptile.order.lowercased() {
        case "testudines":
            return "turtlepin"
        case "serpentes":
            return "snakepin"
        case "sauria":
            return "lizpin"
        default:
            return "turtlepin"
        }
    }
    
    var markerSize: CGFloat {
        switch markerIcon {
        case "snakepin":
            return 32
        case "turtlepin":
            return 37
        case "lizpin":
            return 44
        default:
            return 30
        }
    }
    
    var body: some View {
        Image(markerIcon)
            .resizable()
            .scaledToFit()
            .frame(width: markerSize, height: markerSize)
    }
}
