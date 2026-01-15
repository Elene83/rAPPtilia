enum TaxonomicRank {
    case classRank
    case order
    case family
    case species
}

struct ReptileNode {
    let id: String
    let title: String?
    let description: String
    let rank: TaxonomicRank
    let order: String?
    let family: String?
    
    var circleSize: Double {
        switch rank {
        case .classRank: return 105
        case .order: return 70
        case .family: return 60
        case .species: return 40
        }
    }
    
    var titleSize: Double {
        switch rank {
        case .classRank: return 11
        case .order: return 9
        case .family: return 8
        case .species: return 5
        }
    }
    
    var descriptionSize: Double {
        switch rank {
        case .classRank: return 5
        case .order: return 3
        case .family: return 0
        case .species: return 0
        }
    }
    
    var hasTitle: Bool {
        return rank != .species
    }
}
