import SwiftUI

struct DetailsView: View {
    @StateObject var vm: DetailsViewModel
    @Environment(\.dismiss) var dismiss
    
    //temporary pure ui
    @State private var isFavorite: Bool = false
    
    init(reptile: Reptile) {
          _vm = StateObject(wrappedValue: DetailsViewModel(reptile: reptile))
    }
    
    var body: some View {
        ScrollView {
            ScrollView {
                VStack(spacing: 8) {
                    VStack {
                        Text(vm.reptile.name)
                            .font(.custom("Firago-Light", size: 16))
                            .foregroundColor(Color("AppDarkRed"))

                        CachedAsyncImage(url: URL(string: vm.reptile.thumbnailUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color("AppLightRed")
                        }
                        .frame(width: 300)
                        .cornerRadius(8)
                        .padding(.top, 50)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Description")
                            .font(.custom("Firago-Medium", size: 16))
                            .foregroundStyle(Color("AppBrown"))

                        DescriptionStack(items: vm.descriptionItems)
                        
                        About(
                            description: vm.reptile.about,
                            suborder: vm.reptile.order,
                            family: vm.reptile.family,
                            species: vm.reptile.name
                        )
                        .padding(.top, 13)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .navigationTitle(vm.reptile.commonName)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image("chevronRed")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    //ui only temp
                    isFavorite.toggle()
                }) {
                    Image(isFavorite ? "favoriteActive" : "favorite")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 33)
                        .padding(.trailing, 10)
                        .padding(.top, 6)
                        .frame(height: 50)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBG"))
    }
}
