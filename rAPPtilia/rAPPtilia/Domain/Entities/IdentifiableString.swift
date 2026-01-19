import Foundation

struct IdentifiableImgString: Identifiable {
    let id = UUID()
    let value: String
}
