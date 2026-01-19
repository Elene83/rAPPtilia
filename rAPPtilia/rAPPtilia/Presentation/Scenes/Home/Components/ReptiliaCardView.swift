import UIKit

class ReptiliaCardView: UIView {
    //MARK: Properties
    private let mainStackView = UIStackView()
    private let cardView: CardView
    private let instructionLabel = UILabel()
    
    var hasUserSwiped: Bool = false {
        didSet {
            updateInstructionVisibility()
        }
    }
    
    //MARK: Inits
    init(hasUserSwiped: Bool = false) {
        self.hasUserSwiped = hasUserSwiped
        
        self.cardView = CardView(
            title: "REPTILIA",
            titleSize: Card.CardType.reptiliaClass.size.titleSize,
            text: ReptileData.reptiliaInfo,
            textSize: Card.CardType.reptiliaClass.size.textSize,
            width: Card.CardType.reptiliaClass.size.width,
            height: Card.CardType.reptiliaClass.size.height
        )
        
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
        
        mainStackView.addArrangedSubview(cardView)
        
        instructionLabel.text = "Swipe left to continue, swipe right to go back"
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
        
        mainStackView.setCustomSpacing(30, after: cardView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateInstructionVisibility()
    }
    
    private func updateInstructionVisibility() {
        instructionLabel.isHidden = hasUserSwiped
        
        if hasUserSwiped {
            instructionLabel.layer.removeAllAnimations()
        } else {
            startPulsingAnimation()
        }
    }
    
    private func startPulsingAnimation() {
        guard !hasUserSwiped && instructionLabel.window != nil else { return }
        
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
        
        if window != nil && !hasUserSwiped {
            startPulsingAnimation()
        }
    }
}
