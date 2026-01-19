import UIKit

class ReptileSpeciesCardView: UIView {
    //MARK: Properties
    private let cardView: CardView
    
    //MARK: Inits
    init(reptile: Reptile) {
        self.cardView = CardView(
            title: reptile.commonName,
            titleSize: Card.CardType.species.size.titleSize,
            text: " ",
            textSize: 0,
            width: Card.CardType.species.size.width,
            height: Card.CardType.species.size.height,
            horizontalPadding: 2
        )
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    private func setupView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
