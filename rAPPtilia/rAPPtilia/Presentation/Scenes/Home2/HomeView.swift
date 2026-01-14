import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel
    var navigationController: UINavigationController?
    
    var body: some View {
        ZStack {
            Color("AppBG")
                .ignoresSafeArea()
            
            VStack {
                if let errorMsg = vm.errorMsg {
                    Text("error: \(errorMsg)")
                        .foregroundColor(.red)
                } else {
                    HomeFilter(
                        filters: $vm.filters,
                        allReptiles: vm.allReptiles,
                        onFilterChanged: {
                            vm.applyFilters()
                        }
                    )
                    
                    ReptileCollection(
                        reptiles: vm.reptiles,
                        navigationController: navigationController
                    )
                }
            }
        }
    }
}
