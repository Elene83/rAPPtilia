import SwiftUI

struct ProfileLocations: View {
    //MARK: Properties
    var locations: [LocationModel]
    var getLocationAddress: (LocationModel) -> String
    var onRemove: (String) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                ForEach(locations, id: \.id) { location in
                    ProfileLocationItem(
                        address: getLocationAddress(location),
                        date: formatDate(location.timeStamp),
                        onRemove: { onRemove(location.id) }
                    )
                }
            }
        }
        .frame(maxHeight: 200)
    }
    
    //MARK: Methods
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
