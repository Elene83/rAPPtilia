import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseCore

class FirebaseAuthRepository: AuthRepository {
    func logout(completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private let db = Firestore.firestore()
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1)))
                return
            }
            
            self?.fetchUser(userId: firebaseUser.uid, completion: completion)
        }
    }
    
    func signUp(email: String, password: String, fullName: String, username: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1)))
                return
            }
            
            let user = User(
                id: firebaseUser.uid,
                fullName: fullName,
                username: username,
                email: email,
                imageUrl: "",
                reptiles: []
            )
            
            self?.saveUser(user: user, completion: { result in
                switch result {
                case .success:
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
    
    private func saveUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let userData: [String: Any] = [
            "id": user.id,
            "fullName": user.fullName,
            "username": user.username,
            "email": user.email,
            "imageUrl": user.imageUrl,
            "reptiles": []
        ]
        
        db.collection("users").document(user.id).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data() else {
                completion(.failure(NSError(domain: "AuthError", code: -2)))
                return
            }
            
            let user = User(
                id: data["id"] as? String ?? userId,
                fullName: data["fullName"] as? String ?? "",
                username: data["username"] as? String ?? "",
                email: data["email"] as? String ?? "",
                imageUrl: data["imageUrl"] as? String ?? "",
                reptiles: data["reptiles"] as? [String] ?? [] //TODO: add this to profile
            )
            
            completion(.success(user))
        }
    }
}

extension FirebaseAuthRepository {
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(.failure(NSError(domain: "AuthError", code: -3, userInfo: [NSLocalizedDescriptionKey: "Missing client ID"])))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "AuthError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"])))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let firebaseUser = authResult?.user else {
                    completion(.failure(NSError(domain: "AuthError", code: -1)))
                    return
                }
                
                self?.fetchUser(userId: firebaseUser.uid) { result in
                    switch result {
                    case .success(let existingUser):
                        completion(.success(existingUser))
                    case .failure:
                        let newUser = User(
                            id: firebaseUser.uid,
                            fullName: firebaseUser.displayName ?? "",
                            username: firebaseUser.email?.components(separatedBy: "@").first ?? "",
                            email: firebaseUser.email ?? "",
                            imageUrl: firebaseUser.photoURL?.absoluteString ?? "",
                            reptiles: []
                        )
                        
                        self?.saveUser(user: newUser) { saveResult in
                            switch saveResult {
                            case .success:
                                completion(.success(newUser))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
        }
    }
}
