struct Card: Identifiable {
    var id: Int
    var title: String?
    var titleSize: Double?
    var text: String
    var textSize: Double
    var height: Double
    var width: Double
    var order: String?
    
    enum CardType {
        case reptiliaClass
        case order
        case species
        
        var size: (width: Double, height: Double, titleSize: Double, textSize: Double) {
            switch self {
            case .reptiliaClass:
                return(300, 360, 21, 14)
            case .order:
                return(160, 190, 15, 9)
            case .species:
                return(160, 50, 11, 0)
            }
        }
    }
}
