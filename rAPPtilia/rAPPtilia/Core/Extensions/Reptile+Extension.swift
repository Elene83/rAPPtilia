import SwiftUI

extension Reptile {
    var markerIcon: String {
        switch order.lowercased() {
        case "testudines": return "turtlepin"
        case "serpentes": return "snakepin"
        case "sauria": return "lizpin"
        default: return "turtlepin"
        }
    }
    
    var markerSize: CGFloat {
        switch markerIcon {
        case "snakepin": return 32
        case "turtlepin": return 37
        case "lizpin": return 44
        default: return 30
        }
    }
}
