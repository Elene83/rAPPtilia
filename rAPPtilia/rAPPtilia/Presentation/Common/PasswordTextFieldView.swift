import UIKit

class PasswordTextFieldView: UIView {
    var placeholderString: String
    
    private var isPasswordVisible = false
    
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
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor(named: "AppDarkRed")?.cgColor
        textField.isSecureTextEntry = true
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.tintColor = UIColor(named: "AppDarkRed")
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var rightContainerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        containerView.addSubview(toggleButton)
        
        NSLayoutConstraint.activate([
            toggleButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -11),
            toggleButton.widthAnchor.constraint(equalToConstant: 24),
            toggleButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return containerView
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
        
        textField.rightView = rightContainerView
        textField.rightViewMode = .always
            
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
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible
        
        let imageName = isPasswordVisible ? "eye.fill" : "eye.slash.fill"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
