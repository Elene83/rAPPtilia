import Foundation
import FirebaseAuth

class SignUpViewModel {
    var onSignUpSuccess: (() -> Void)?
    var onSignUpError: ((String) -> Void)?
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.onSignUpError?(error.localizedDescription)
                return
            }
            
            self?.onSignUpSuccess?()
        }
    }
}

//checkebi
