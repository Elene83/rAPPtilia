import SwiftUI

struct ChatOpenedView: View {
    let coordinator: MainCoordinator

    var body: some View {
        VStack(spacing: 0) {
            TopSide()
        }
        .padding(.top, -110)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("AppBG"))
    }
}

