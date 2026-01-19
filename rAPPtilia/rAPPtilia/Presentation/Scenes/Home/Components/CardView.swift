import UIKit

class CardView: UIView {
    //MARK: Properties
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    private let stackView = UIStackView()
    
    private var title: String
    private var titleSize: Double
    private var text: String
    private var textSize: Double
    private var cardWidth: Double
    private var cardHeight: Double
    private var horizontalPadding: Double
    private var bottomPadding: Double
    private var spacing: Double
    
    //MARK: Inits
    init(title: String,
         titleSize: Double,
         text: String,
         textSize: Double,
         width: Double,
         height: Double,
         horizontalPadding: Double = 25,
         bottomPadding: Double = 15,
         spacing: Double = 20) {
        
        self.title = title
        self.titleSize = titleSize
        self.text = text
        self.textSize = textSize
        self.cardWidth = width
        self.cardHeight = height
        self.horizontalPadding = horizontalPadding
        self.bottomPadding = bottomPadding
        self.spacing = spacing
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    private func setupView() {
        stackView.axis = .vertical
        stackView.spacing = spacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Firago-Heavy", size: titleSize)
        titleLabel.textColor = UIColor(named: "AppTextColor")
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        stackView.addArrangedSubview(titleLabel)
        
        if !text.isEmpty && textSize > 0 {
            textLabel.text = text
            textLabel.font = UIFont(name: "Firago-Regular", size: textSize)
            textLabel.textColor = UIColor(named: "AppTextColor")
            textLabel.textAlignment = .left
            textLabel.numberOfLines = 0
            stackView.addArrangedSubview(textLabel)
            
            NSLayoutConstraint.activate([
                textLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: horizontalPadding),
                textLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -horizontalPadding)
            ])
            
            stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 0)
            stackView.isLayoutMarginsRelativeArrangement = true
        }
        
        backgroundColor = UIColor(named: "AppWhiteBG")
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        layer.borderColor = UIColor(named: "AppDarkRed")?.cgColor
        layer.borderWidth = 1.5
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            widthAnchor.constraint(equalToConstant: cardWidth),
            heightAnchor.constraint(equalToConstant: cardHeight)
        ])
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection) in
            self.layer.borderColor = UIColor(named: "AppDarkRed")?.cgColor
        }
    }
}
