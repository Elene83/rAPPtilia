import SwiftUI

struct CardView: View {
    let title: String
    let titleSize: Double
    let text: String
    let textSize: Double
    let width: Double
    let height: Double
    var horizontalPadding: Double = 25
    var bottomPadding: Double = 15
    var spacing: Double = 20
    
    var body: some View {
        VStack(spacing: spacing) {
            Text(title)
                .font(.custom("Firago-Heavy", size: titleSize))
                .foregroundStyle(Color("AppTextColor"))
            
            if !text.isEmpty && textSize > 0 {
                Text(text)
                    .font(.custom("Firago-Regular", size: textSize))
                    .foregroundStyle(Color("AppTextColor"))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, horizontalPadding)
                    .padding(.bottom, bottomPadding)
            }
        }
        .frame(width: width, height: height, alignment: .center)
        .background(Color("AppWhiteBG"))
        .cornerRadius(8)
        .overlay(
               RoundedRectangle(cornerRadius: 8)
                .stroke(Color("AppDarkRed"), lineWidth: 1.5)
        )
    }
}
