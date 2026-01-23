import SwiftUI

struct DetailsView: View {
    @StateObject var vm: DetailsViewModel
    @State private var isFavorite: Bool = false
    @State private var selectedImage: String? = nil
    
    init(reptile: Reptile) {
        _vm = StateObject(wrappedValue: DetailsViewModel(reptile: reptile))
    }
    
    @ViewBuilder
    private var placeholderImg: some View {
        if vm.reptile.order == "Serpentes" {
            Image("snekplaceholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if vm.reptile.order == "Testudines" {
            Image("turtleplaceholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image("lizplaceholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    var body: some View {
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
                        placeholderImg
                            .frame(width: 200)
                    }
                    .frame(width: 300)
                    .cornerRadius(8)
                    .padding(.top, 50)
                    
                    if !vm.reptile.images.isEmpty {
                        ImagesStack(
                            imageUrls: vm.reptile.images,
                            selectedImage: $selectedImage
                        )
                        .padding(.horizontal, 20)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Description")
                        .font(.custom("Firago-Medium", size: 16))
                        .foregroundStyle(Color("AppBrown"))
                        .padding(.top, 13)

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
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .overlay {
            if let imageUrl = selectedImage {
                ImageOverlay(
                    isPresented: Binding(
                        get: { selectedImage != nil },
                        set: { if !$0 { selectedImage = nil } }
                    ),
                    imageUrl: imageUrl
                )
                .transition(.opacity.combined(with: .scale(0.95)))
                .animation(.easeInOut(duration: 0.25), value: selectedImage)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    popViewController()
                }) {
                    Image("chevronRed")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    vm.toggleFavorite()
                }) {
                    Image(vm.isFavorite ? "favoriteActive" : "favorite")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 33)
                        .padding(.trailing, 10)
                        .padding(.top, 4)
                        .frame(height: 50)
                        .opacity(vm.isLoading ? 0.5 : 1.0)
                }
                .disabled(vm.isLoading)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBG"))
    }
    
    private func popViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let tabBar = window.rootViewController as? UITabBarController,
              let navController = tabBar.selectedViewController as? UINavigationController else {
            return
        }
        navController.popViewController(animated: true)
    }
}
