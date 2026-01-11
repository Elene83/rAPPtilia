import UIKit

protocol AuthRepository {
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signUp(email: String, password: String, fullName: String, username: String, completion: @escaping (Result<User, Error>) -> Void)
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
}
