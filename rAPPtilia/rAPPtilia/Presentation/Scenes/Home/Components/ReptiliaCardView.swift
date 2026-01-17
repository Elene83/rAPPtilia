import SwiftUI

struct ReptiliaCardView: View {
    @State private var textOpacity: Double = 1.0
    @Binding var hasUserSwiped: Bool
    
    var body: some View {
        VStack {
            CardView(
                title: "REPTILIA",
                titleSize: Card.CardType.reptiliaClass.size.titleSize,
                text: ReptileData.reptiliaInfo,
                textSize: Card.CardType.reptiliaClass.size.textSize,
                width: Card.CardType.reptiliaClass.size.width,
                height: Card.CardType.reptiliaClass.size.height
            )
            
            if !hasUserSwiped {
                Text("Swipe left to continue, swipe right to go back")
                    .font(.custom("Firago-Regular", size: 13))
                    .foregroundColor(Color(uiColor: UIColor(named: "AppDarkRed") ?? .red))
                    .opacity(textOpacity)
                    .padding(.top, 30)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            textOpacity = 0.3
                        }
                    }
                    .transition(.opacity)
            }
            Spacer()
        }
        .padding(.top, 80)
    }
}
