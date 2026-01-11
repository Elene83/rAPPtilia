import UIKit

class LoginViewController: UIViewController {
    //MARK: Properties
    weak var coordinator: AuthCoordinator?
    private let viewModel: LoginViewModel
    private let bottomText = BottomText()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "redsnek")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "rAPPtilia"
        label.font = UIFont(name: "FiraGO-Medium", size: 24)
        label.textColor = UIColor(named: "AppDarkRed")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
    
    private let googleButton: CustomButton = {
        let button = CustomButton(
            title: "Try with Google",
            backgroundColor: .clear,
            cornerRadius: 8,
            icon: UIImage(named: "googleIcon"),
            hasOutline: true,
            outlineColor: UIColor(named: "AppDarkRed"),
            textColor: UIColor(named: "AppDarkRed")
        )
        
        return button
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton(
            title: "Log In",
            backgroundColor: UIColor(named: "AppDarkRed"),
            cornerRadius: 8
        )
        
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ssskip", for: .normal)
        button.titleLabel?.font = UIFont(name: "FiraGO-Medium", size: 16)
        button.setTitleColor(UIColor(named: "AppDarkRed"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let skipSubText: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AppDarkRed")
        label.text = "for now..."
        label.font = UIFont(name: "FiraGO-Regular", size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    //MARK: Inits
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppBG")
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupBindings()
        setupActions()
        hideKeyboardOnTap()
    }
    
    //MARK: Methods
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(googleButton)
        view.addSubview(loginButton)
        view.addSubview(skipButton)
        view.addSubview(skipSubText)
        view.addSubview(bottomText)
        
        bottomText.onSignUpTapped = {[weak self] in
            self?.coordinator?.showSignUp()
        }
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 300),
            logoImageView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -70),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                   
            emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 40),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            bottomText.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            bottomText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            googleButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -15),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            googleButton.heightAnchor.constraint(equalToConstant: 50),
                   
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            skipSubText.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 1),
            skipSubText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22)
        ])
    }
    
    private func setupBindings() {
        viewModel.onLoginSuccess = { [weak self] in
            self?.coordinator?.loginDidSucceed()
        }
        
        viewModel.onLoginError = { [weak self] errorMessage in
            //TODO: handle when ui is built
            print("Login error: \(errorMessage)")
        }
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
    }

    @objc private func loginTapped() {
        guard let email = emailField.textField.text,
              let password = passwordField.textField.text else {
            return
        }
        
        viewModel.login(email: email, password: password)
    }

    @objc private func googleSignInTapped() {
        viewModel.signInWithGoogle(presentingViewController: self)
    }
    
    @objc private func skipTapped() {
        //skip button daamate romelic homeze wagviyvans
        coordinator?.loginDidSucceed()
    }
}

#warning("outside click should cancel the keyboard")
