//
//  FirebaseUseCase.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import Combine

class FirebaseUseCase {
    
    private let firebaseRepository = FirebaseRepositoryImpl()
    private let appStorageManager = AppStorageManager()
    
    func gameHasNewerVersion(currentVersion: Int) -> AnyPublisher<Bool, any Error> {
        return firebaseRepository.gameHasNewerVersion(currentVersion: currentVersion)
    }

    func getTop20RankingList() -> AnyPublisher<[Ranking], any Error> {
        return firebaseRepository.getRankingList()
                .map { list in
                    // sort by descending + take first 20 elements
                    return list.sorted(by: { $0.score > $1.score }).prefix(20).map { $0 }
                }
                .eraseToAnyPublisher()
    }

    func saveNewRecord(score: Int, name: String, countryId: String) {
        firebaseRepository.saveNewRecord(score: score, name: name, countryId: countryId)
        appStorageManager.setUserCompletedGame()
    }
}
