import SwiftUI

struct SpeciesSelectionModal: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Which one was it?")
                .font(.custom("Firago-SemiBold", size: 16))
                .foregroundColor(Color("AppOrangeFont"))
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            ScrollView {
                LazyVStack(spacing: 5) {
                    ForEach(viewModel.filteredReptilesByOrder) { reptile in
                        HStack(spacing: 10) {
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(reptile.commonName)
                                    .font(.custom("Firago-Regular", size: 14))
                                    .foregroundColor(Color("AppOrangeFont"))
                            }
                            
                            Spacer()
                            
                            Button {
                                if !reptile.images.isEmpty {
                                    viewModel.showImagePreview(reptile.images[0])
                                }
                            } label: {
                                Image("imageIcon")
                                    .frame(width: 13, height: 13)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Color("AppBG"))
                        .onTapGesture {
                            viewModel.selectSpecies(reptile)
                        }
                    }
                }
            }
            .frame(maxHeight: 150)
            .padding(.bottom, 15)
        }
        .background(Color("AppBG"))
        .cornerRadius(10)
        .frame(width: 250)
    }
}
