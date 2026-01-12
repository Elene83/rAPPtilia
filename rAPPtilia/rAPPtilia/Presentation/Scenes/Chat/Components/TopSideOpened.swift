import SwiftUI

struct TopSideOpened: View {
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color("AppBG"))
                .frame(maxWidth: .infinity)
                .frame(height: 140)
            
            Image("greentort")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
