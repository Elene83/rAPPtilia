import UIKit

class OrderCardsView: UIView {
    //MARK: Properties
    private let mainStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    private let instructionLabel = UILabel()
    private var onOrderTapped: ((String) -> Void)?
    
    private let orders: [(String, String)] = [
        ("SERPENTES", ReptileData.serpentesInfo),
        ("TESTUDINES", ReptileData.testudinesInfo),
        ("SAURIA", ReptileData.sauriaInfo)
    ]
    
    var hasUserTapped: Bool = false {
        didSet {
            updateInstructionVisibility()
        }
    }
    
    //MARK: Inits
    init(hasUserTapped: Bool = false, onOrderTapped: @escaping (String) -> Void) {
        self.hasUserTapped = hasUserTapped
        self.onOrderTapped = onOrderTapped
        super.init(frame: .zero)
        setupView()
        startPulsingAnimation()
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
        
        instructionLabel.text = "Tap on a card to see more!"
        instructionLabel.font = UIFont(name: "Firago-Regular", size: 13)
        instructionLabel.textColor = UIColor(named: "AppDarkRed") ?? .red
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.alpha = 1.0
        mainStackView.addArrangedSubview(instructionLabel)
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        mainStackView.addArrangedSubview(spacer)
        
        mainStackView.setCustomSpacing(17, after: firstCard)
        mainStackView.setCustomSpacing(30, after: horizontalStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateInstructionVisibility()
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
        hasUserTapped = true
        onOrderTapped?(orderName)
    }
    
    private func updateInstructionVisibility() {
        instructionLabel.isHidden = hasUserTapped
        
        if hasUserTapped {
            instructionLabel.layer.removeAllAnimations()
        } else {
            startPulsingAnimation()
        }
    }
    
    private func startPulsingAnimation() {
        guard !hasUserTapped && instructionLabel.window != nil else { return }
        
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            options: [.autoreverse, .repeat, .allowUserInteraction, .curveEaseInOut],
            animations: {
                self.instructionLabel.alpha = 0.3
            }
        )
    }
    
    //MARK: Lifecycle
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil && !hasUserTapped {
            startPulsingAnimation()
        }
    }
}
