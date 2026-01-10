import UIKit

class CustomTextFieldView: UIView {
    var placeholderString: String
    
    var label: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(named: "AppDarkRed")
        label.font = UIFont(name: "FiraGO-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var textField: UITextField = {
        var textField = UITextField()
        textField.font = UIFont(name: "FiraGO-Regular", size: 14)
        textField.textColor = UIColor(named: "AppDarkRed")
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor(named: "AppDarkRed")?.cgColor
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 0))
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    init(placeholderString: String) {
        self.placeholderString = placeholderString
        super.init(frame: .zero)
        setupView()
        configurePlaceholder()
    }
 
    override init(frame: CGRect) {
        self.placeholderString = ""
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configurePlaceholder() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "FiraGO-Regular", size: 14)!,
            .foregroundColor: UIColor(named: "AppLightRed")!
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: attributes)
    }
    
    private func setupView() {
        addSubview(label)
        addSubview(textField)
            
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
                
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 45),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
