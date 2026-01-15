import Foundation
import FirebaseFirestore

protocol UserRepositoryProtocol {
    func addFavorite(userId: String, reptileId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func removeFavorite(userId: String, reptileId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getFavorites(userId: String, completion: @escaping (Result<[String], Error>) -> Void)
}

class UserRepository: UserRepositoryProtocol {
    private let db = Firestore.firestore()
    
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
