//
//  FirebaseRepositoryImpl.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import FirebaseFirestore
import Foundation
import Combine

class FirebaseRepositoryImpl: IFirebaseRepository {
    
    private var firestore = Firestore.firestore()
    
    func gameHasNewerVersion(currentVersion: Int) -> AnyPublisher<Bool, any Error> {
        let collection: DocumentReference = firestore.collection(Constants.SETTINGS).document("JQLvfCyWopfOC1gxKfC8")
        return collection.documentListenerFlow(AndroidBuildVersion.self).map { serverVersion in
            return currentVersion >= serverVersion?.android_build_number ?? 0
        }.eraseToAnyPublisher()
    }
    
    func getRankingList() -> AnyPublisher<[Ranking], any Error> {
        let serviceEventsCollection = firestore.collection(Constants.RANKING)
        return serviceEventsCollection.collectionListenerFlow(Ranking.self)
    }
    
    func saveNewRecord(score: Int, name: String, countryId: String) {
        let data: [String: Any] = [
                "country_id": countryId,
                "score": score,
                "user_name": name
            ]
            
        firestore.collection(Constants.RANKING).addDocument(data: data) { error in
                if let error = error {
                    print("AQUI: Error adding document: \(error)")
                } else {
                    print("AQUI: Document added successfully")
                }
            }
    }
    
}

