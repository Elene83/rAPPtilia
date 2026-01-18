import UIKit
import FirebaseFirestore
import FirebaseStorage

protocol UserRepositoryProtocol {
    func addFavorite(userId: String, reptileId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func removeFavorite(userId: String, reptileId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getFavorites(userId: String, completion: @escaping (Result<[String], Error>) -> Void)
    
    func updateFullName(userId: String, fullName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func updateUsername(userId: String, userName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func uploadProfileImage(userId: String, image: UIImage, completion: @escaping (Result<Void, Error>) -> Void)
    func updateProfileImage(userId: String, imageUrl: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class UserRepository: UserRepositoryProtocol {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func updateFullName(userId: String, fullName: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        db.collection("users").document(userId).updateData([
            "fullName": fullName
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUsername(userId: String, userName: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        db.collection("users").document(userId).updateData([
            "username": userName
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func uploadProfileImage(userId: String, image: UIImage, completion: @escaping (Result<Void, any Error>) -> Void) {
        print("orwam")
    }
    
    func updateProfileImage(userId: String, imageUrl: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        print("orwam")
    }
    
    func addFavorite(userId: String, reptileId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userId).updateData([
            "reptiles": FieldValue.arrayUnion([reptileId])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func removeFavorite(userId: String, reptileId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userId).updateData([
            "reptiles": FieldValue.arrayRemove([reptileId])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getFavorites(userId: String, completion: @escaping (Result<[String], Error>) -> Void) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data(),
                  let reptiles = data["reptiles"] as? [String] else {
                completion(.success([]))
                return
            }
            
            completion(.success(reptiles))
        }
    }
}
