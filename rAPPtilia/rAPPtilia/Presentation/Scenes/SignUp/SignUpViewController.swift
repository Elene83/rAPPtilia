import UIKit

class SignUpViewController: UIViewController {
    //MARK: Properties
    weak var coordinator: AuthCoordinator?
    private let viewModel = SignUpViewModel()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "chevron"), for: .normal)
        button.tintColor = UIColor(named: "AppDarkRed")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.font = UIFont(name: "FiraGO-Medium", size: 24)
        label.textColor = UIColor(named: "AppDarkRed")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fullNameField: CustomTextFieldView = {
        let field = CustomTextFieldView(placeholderString: "Your full name")
        field.label.text = "Full Name"
        field.textField.autocapitalizationType = .words
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let usernameField: CustomTextFieldView = {
        let field = CustomTextFieldView(placeholderString: "Your username")
        field.label.text = "Username"
        field.textField.autocapitalizationType = .none
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let emailField: CustomTextFieldView = {
        let field = CustomTextFieldView(placeholderString: "Your email address")
        field.label.text = "Email"
        field.textField.keyboardType = .emailAddress
        field.textField.autocapitalizationType = .none
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let passwordField: PasswordTextFieldView = {
        let field = PasswordTextFieldView(placeholderString: "Your password")
        field.label.text = "Password"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let confirmPasswordField: PasswordTextFieldView = {
        let field = PasswordTextFieldView(placeholderString: "Confirm your password")
        field.label.text = "Confirm Password"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let signUpButton: CustomButton = {
        let button = CustomButton(
            title: "Sign Up",
            backgroundColor: UIColor(named: "AppDarkRed"),
            cornerRadius: 8
        )
        return button
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppBG")
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupBindings()
        setupActions()
    }
    
    //MARK: Methods
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(fullNameField)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            fullNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            fullNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            fullNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            usernameField.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 24),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 24),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 24),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            confirmPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            confirmPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupBindings() {
        viewModel.onSignUpSuccess = { [weak self] in
            self?.coordinator?.signUpDidSucceed()
        }
        
        viewModel.onSignUpError = { [weak self] errorMessage in
            //TODO: handle after ui
            print("Sign up error: \(errorMessage)")
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    //TODO: call sign up from vm when ui ready
}

//TODO: analogiurad on outside click let it retract keyboard
