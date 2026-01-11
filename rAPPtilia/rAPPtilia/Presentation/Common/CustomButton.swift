import UIKit

class CustomButton: UIButton {
    init(
        title: String,
        backgroundColor: UIColor?,
        cornerRadius: CGFloat = 8,
        icon: UIImage? = nil,
        hasOutline: Bool = false,
        outlineColor: UIColor? = nil,
        textColor: UIColor? = nil
    ) {
        super.init(frame: .zero)
        
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = textColor ?? UIColor(named: "AppBG")
        config.cornerStyle = .fixed
        
        var titleAttr = AttributedString(title)
        titleAttr.font = UIFont(name: "FiraGO-Medium", size: 18)
        config.attributedTitle = titleAttr
        
        if let icon = icon {
            config.image = icon
            config.imagePlacement = .leading
            config.imagePadding = 8
        }
        
        self.configuration = config
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if hasOutline {
            layer.borderWidth = 1.5
            layer.borderColor = (outlineColor ?? UIColor(named: "AppDarkRed"))?.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
