import SwiftUI

struct ReptileCollection: View {
    var reptiles: [Reptile]

    let columns = [
        GridItem(.flexible(), spacing: 55),
        GridItem(.flexible(), spacing: 55),
        GridItem(.flexible(), spacing: 55)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 55) {
                ForEach(reptiles) { reptile in
                    ReptileCell(
                        image: reptile.thumbnailUrl,
                        commonName: reptile.commonName,
                        name: reptile.name
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 55)
            .padding(.top, 20)
        }
    }
}
