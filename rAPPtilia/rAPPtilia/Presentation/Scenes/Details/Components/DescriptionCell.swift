import SwiftUI

struct DescriptionCell: View {
    var descriptionLabel: String
    var descriptionString: String
    
    var body: some View {
        VStack (alignment: .leading, spacing: 3) {
        Text(descriptionLabel)
            .font(.custom("Firago-Medium", size: 13))
            .foregroundStyle(Color("AppLightBrown"))
        
        Text(descriptionString)
            .font(.custom("Firago-Medium", size: 13))
            .foregroundStyle(Color("AppBrown"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
