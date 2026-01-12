import SwiftUI

struct TopSide: View {
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Image(viewModel.isTapped ? "tappedTort" : "greentort")
                .resizable()
                .scaledToFit()
                .frame(width: 360, height: 360)
                .onTapGesture {
                    viewModel.handleTap()
                }
            
            Text("Curious? Ask away!")
                .foregroundStyle(Color("AppDarkRed"))
                .font(.custom("Firago-Regular", size: 13))
                .fixedSize()
                .rotationEffect(.degrees(-20))
                .offset(x: 100, y: 80)
                .padding(.trailing, 20) 
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
