import SwiftUI

struct ReptileSpeciesCard: View {
    let reptile: Reptile
        var body: some View {
            CardView(
                title: reptile.commonName,
                titleSize: Card.CardType.species.size.titleSize,
                text: " ",
                textSize: 0,
                width: Card.CardType.species.size.width,
                height: Card.CardType.species.size.height,
                horizontalPadding: 2
            )
        }
}
