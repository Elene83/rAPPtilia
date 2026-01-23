import SwiftUI

struct ReptileCell: View {
    var image: String?
    var commonName: String?
    var name: String?
    var reptileOrder: String?
    
    @ViewBuilder
    private var placeholderImg: some View {
        if reptileOrder == "Serpentes" {
            Image("snekplaceholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if reptileOrder == "Testudines" {
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
           VStack(alignment: .center, spacing: 5) {
               if let image = image {
                   CachedAsyncImage(url: URL(string: image)) { image in
                       image
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                   } placeholder: {
                       placeholderImg
                   }
                   .frame(height: 75)
                   .cornerRadius(4)
               }
               
               if let commonName = commonName {
                   Text(commonName)
                       .font(.custom("Firago-Regular", size: 10))
                       .foregroundStyle(Color("AppDarkRed"))
                       .lineLimit(1)
               }
               
               if let name = name {
                   Text(name)
                       .font(.custom("Firago-Light", size: 8))
                       .foregroundStyle(Color("AppDarkRed"))
                       .lineLimit(1)
            }
        }
    }
}
