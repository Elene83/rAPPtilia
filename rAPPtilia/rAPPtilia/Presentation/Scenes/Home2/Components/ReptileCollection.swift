import SwiftUI

struct ReptileCollection: View {
    var reptiles: [Reptile]
    var navigationController: UINavigationController?
    
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
                        name: reptile.name,
                        reptileOrder: reptile.order
                    )
                    .onTapGesture {
                        navigateToDetails(reptile: reptile)
                        print("hi?")
                    }
                    .onLongPressGesture(minimumDuration: 0.5, perform: {
                        print("hi im zoomed in")
                    })
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 55)
            .padding(.top, 20)
        }
    }
    
    private func navigateToDetails(reptile: Reptile) {
        guard let navController = navigationController else { return }
        
        let detailsView = DetailsView(reptile: reptile)
        let detailsVC = UIHostingController(rootView: detailsView)
        detailsVC.navigationItem.title = reptile.commonName
        detailsVC.navigationItem.hidesBackButton = true 
        
        navController.pushViewController(detailsVC, animated: true)
    }
}
