import UIKit

class OrderCardsView: UIView {
    //MARK: Properties
    private let mainStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    private var onOrderTapped: ((String) -> Void)?
    
    private let orders: [(String, String)] = [
        ("SERPENTES", ReptileData.serpentesInfo),
        ("TESTUDINES", ReptileData.testudinesInfo),
        ("SAURIA", ReptileData.sauriaInfo)
    ]
    
    //MARK: Inits
    init(onOrderTapped: @escaping (String) -> Void) {
        self.onOrderTapped = onOrderTapped
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    private func setupView() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 0
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        let firstCard = createCard(for: orders[0])
        mainStackView.addArrangedSubview(firstCard)
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 30
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .equalSpacing
        mainStackView.addArrangedSubview(horizontalStackView)
        
        for order in orders.dropFirst() {
            let card = createCard(for: order)
            horizontalStackView.addArrangedSubview(card)
        }
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        mainStackView.addArrangedSubview(spacer)
        
        mainStackView.setCustomSpacing(17, after: firstCard)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createCard(for order: (String, String)) -> CardView {
        let cardView = CardView(
            title: order.0,
            titleSize: Card.CardType.order.size.titleSize,
            text: order.1,
            textSize: Card.CardType.order.size.textSize,
            width: Card.CardType.order.size.width,
            height: Card.CardType.order.size.height,
            horizontalPadding: 10,
            spacing: 10
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        cardView.addGestureRecognizer(tapGesture)
        cardView.isUserInteractionEnabled = true
        cardView.tag = orders.firstIndex(where: { $0.0 == order.0 }) ?? 0
        
        return cardView
    }
    
    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
        guard let cardView = sender.view, cardView.tag < orders.count else { return }
        let orderName = orders[cardView.tag].0
        onOrderTapped?(orderName)
    }
}
