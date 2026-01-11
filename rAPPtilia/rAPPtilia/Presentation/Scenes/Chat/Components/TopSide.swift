import SwiftUI

struct TopSide: View {
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image("greentort")
                    .frame(width: 250)
            }
            
            Text("Curious? Ask away!")
                .foregroundStyle(Color("AppDarkRed"))
                .font(.custom("Firago-Regular", size: 13))
                .fixedSize()
                .rotationEffect(.degrees(-20))
                .offset(x: 100, y: 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
