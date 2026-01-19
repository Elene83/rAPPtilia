import SwiftUI

struct AddLocationButton: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        Button {
            if viewModel.isAddingLocation {
                viewModel.cancelAddingLocation()
            } else {
                viewModel.startAddingLocation()
            }
        } label: {
            Image("plusIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 21)
                .foregroundColor(viewModel.isAddingLocation ? Color("AppBG") : Color("AppDarkGreen"))
                .rotationEffect(.degrees(viewModel.isAddingLocation ? 45 : 0))
                .padding()
                .background(viewModel.isAddingLocation ? Color("AppDarkGreen") : Color("AppBG"))
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
}
