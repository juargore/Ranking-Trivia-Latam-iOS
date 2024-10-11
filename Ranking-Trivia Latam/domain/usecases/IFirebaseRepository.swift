//
//  IFirebaseRepository.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import Combine

protocol IFirebaseRepository {
    
    func gameHasNewerVersion(currentVersion: Int) -> AnyPublisher<Bool, Error>
    
    func getRankingList() -> AnyPublisher<[Ranking], Error>
    
    func saveNewRecord(score: Int, name: String, countryId: String)
}
