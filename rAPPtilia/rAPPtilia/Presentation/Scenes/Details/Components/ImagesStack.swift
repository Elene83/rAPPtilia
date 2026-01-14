import SwiftUI

struct ImagesStack: View {
    var imageUrls: [String]
    @Binding var selectedImage: String?
    
    var body: some View {
        HStack(spacing: 30) {
            ForEach(imageUrls.prefix(3), id: \.self) { url in
                CachedAsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color("AppLightRed")
                }
                .frame(width: 100, height: 65)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .onTapGesture {
                    selectedImage = url
                }
            }
        }
    }
}
