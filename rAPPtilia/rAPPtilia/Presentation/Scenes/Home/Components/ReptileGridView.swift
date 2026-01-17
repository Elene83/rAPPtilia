import SwiftUI

struct ReptileGridView: View {
    let reptiles: [Reptile]
    let order: String
    weak var coordinator: MainCoordinator?
    let navigationController: UINavigationController?
    let onBack: () -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(reptiles) { reptile in
                        ReptileSpeciesCard(reptile: reptile)
                            .onTapGesture {
                                if let nav = navigationController, let coord = coordinator {
                                    coord.showDetails(for: reptile, from: nav)
                                }
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        onBack()
                    }
                }
        )
    }
}
