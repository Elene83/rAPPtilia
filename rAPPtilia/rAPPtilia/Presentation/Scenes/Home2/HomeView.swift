import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel
    
    var body: some View {
        ZStack {
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
                                        
                    ReptileCollection(reptiles: vm.reptiles)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBG"))
    }
}
