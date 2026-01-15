import SwiftUI

struct ProfileReptiles: View {
    var reptiles: [Reptile]
    var onRemove: (String) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 15) {
                ForEach(reptiles, id: \.self) { reptile in
                    ProfileReptileItem(name: reptile.commonName, scientificName: reptile.name, onRemove: { onRemove(reptile.id) })
                }
            }
        }
        .frame(height: 200)
    }
}
