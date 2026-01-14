import SwiftUI

struct DetailsView: View {
    var reptile: Reptile
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text(reptile.name)
                    .font(.custom("Firago-Light", size: 16))
                    .foregroundColor(Color("AppDarkRed"))
                
                CachedAsyncImage(url: URL(string: reptile.thumbnailUrl)) { image in
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
        }
        .navigationTitle(reptile.commonName)
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
                HStack {
                    Image("favorite")
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
