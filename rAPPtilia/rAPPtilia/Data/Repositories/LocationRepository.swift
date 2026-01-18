import UIKit
import FirebaseFirestore

protocol LocationRepositoryProtocol {
    func addLocation(userId: String, location: LocationModel, completion: @escaping (Result<Void, Error>) -> Void)
    func removeLocation(userId: String, locationId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getLocations(userId: String, completion: @escaping (Result<[LocationModel], Error>) -> Void)
    func getAllLocations(completion: @escaping (Result<[LocationModel], Error>) -> Void)
}

class LocationRepository: LocationRepositoryProtocol {
    private let db = Firestore.firestore()
    
    func addLocation(userId: String, location: LocationModel, completion: @escaping (Result<Void, any Error>) -> Void) {
        let locationData: [String: Any] = [
            "id": location.id,
            "latitude": location.latitude,
            "longitude": location.longitude,
            "reptileId": location.reptileId,
            "userId": location.userId,
            "timestamp": Timestamp(date: location.timeStamp)
        ]
        
        db.collection("users")
            .document(userId)
            .collection("locations")
            .document(location.id)
            .setData(locationData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    func removeLocation(userId: String, locationId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        db.collection("users")
            .document(userId)
            .collection("locations")
            .document(locationId)
            .delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    func getLocations(userId: String, completion: @escaping (Result<[LocationModel], any Error>) -> Void) {
        db.collection("users")
            .document(userId)
            .collection("locations")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let locations = documents.compactMap { docum -> LocationModel? in
                    let data = docum.data()
                    guard let id = data["id"] as? String,
                          let latitude = data["latitude"] as? Double,
                          let longitude = data["longitude"] as? Double,
                          let reptileId = data["reptileId"] as? String,
                          let userId = data["userId"] as? String,
                          let timeStamp = data["timeStamp"] as? Timestamp else {
                        return nil
                    }
                return LocationModel(
                    id:id,
                    latitude: latitude,
                    longitude: longitude,
                    reptileId: reptileId,
                    userId: userId,
                    timeStamp: timeStamp.dateValue()
                )
            }
                completion(.success(locations))
        }
    }
    
    func getAllLocations(completion: @escaping (Result<[LocationModel], any Error>) -> Void) {
        db.collectionGroup("locations")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let locations = documents.compactMap { doc -> LocationModel? in
                    let data = doc.data()
                    guard let id = data["id"] as? String,
                          let latitude = data["latitude"] as? Double,
                          let longitude = data["longitude"] as? Double,
                          let reptileId = data["reptileId"] as? String,
                          let userId = data["userId"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    
                    return LocationModel(
                        id: id,
                        latitude: latitude,
                        longitude: longitude,
                        reptileId: reptileId,
                        userId: userId,
                        timeStamp: timestamp.dateValue()
                    )
                }
                completion(.success(locations))
            }
        }
}

