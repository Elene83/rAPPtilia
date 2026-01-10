import UIKit

class CustomButton: UIButton {
    
    init(title: String, backgroundColor: UIColor?, cornerRadius: CGFloat = 8) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: "FiraGO-Medium", size: 20)
        self.backgroundColor = backgroundColor
        setTitleColor(UIColor(named: "AppBG"), for: .normal)
        layer.cornerRadius = cornerRadius
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
