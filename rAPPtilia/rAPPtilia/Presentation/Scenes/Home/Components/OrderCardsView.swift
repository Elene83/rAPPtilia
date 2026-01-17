import SwiftUI

struct OrderCardsView: View {
    let onOrderTapped: (String) -> Void
    
    private let orders = [
        ("SERPENTES", ReptileData.serpentesInfo),
        ("TESTUDINES", ReptileData.testudinesInfo),
        ("SAURIA", ReptileData.sauriaInfo)
    ]
    
    var body: some View {
        VStack() {
            CardView(
                title: orders[0].0,
                titleSize: Card.CardType.order.size.titleSize,
                text: orders[0].1,
                textSize: Card.CardType.order.size.textSize,
                width: Card.CardType.order.size.width,
                height: Card.CardType.order.size.height,
                horizontalPadding: 10,
                spacing: 10
            )
            .onTapGesture {
                onOrderTapped(orders[0].0)
            }
            
            HStack(spacing: 30) {
                ForEach(orders.dropFirst(), id: \.0) { order in
                    CardView(
                        title: order.0,
                        titleSize: Card.CardType.order.size.titleSize,
                        text: order.1,
                        textSize: Card.CardType.order.size.textSize,
                        width: Card.CardType.order.size.width,
                        height: Card.CardType.order.size.height,
                        horizontalPadding: 10,
                        spacing: 10
                    )
                    .onTapGesture {
                        onOrderTapped(order.0)
                    }
                }
            }
            .padding(.top, 17)

            
            Spacer()
        }
        .padding(.top, 60)
    }
}
