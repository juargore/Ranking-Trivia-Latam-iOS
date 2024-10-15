//
//  HallOfFameViewModel.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import Combine
import SwiftUI

final class HallOfFameViewModel: ObservableObject {
    
    private let firebaseUseCase = FirebaseUseCase()
    private let appStorageUseCase = AppStorageUseCase()
    private let gameUseCase = GameUseCase()
    private var disposables = Set<AnyCancellable>()
    
    @Published var ranking: [Ranking] = []
    
    public init() {
        getTop20RankingList()
    }
    
    private func getTop20RankingList() {
        firebaseUseCase
            .getTop20RankingList()
            .sink { _ in } receiveValue: { [weak self] list in
                var updatedList: [Ranking] = []
                
                for item in list {
                    var mutableItem = item
                    if let flagId = getFlagId(flagCode: item.country_id) {
                        mutableItem.flag = self?.gameUseCase.getFlagById(flagId: flagId)
                    }
                    updatedList.append(mutableItem)
                }
                
                self?.ranking = updatedList
            }.store(in: &disposables)
    }
    
    func incrementScore(_ question: Question, isCorrect: Bool) {
        let points = if isCorrect {
            getPointsForCorrectResponse(question.level)
        } else {
            getPointsForIncorrectResponse(question.level)
        }
        appStorageUseCase.incrementScore(points: points)
    }
    
    func getPointsToAnimate(_ question: Question, _ isCorrect: Bool) -> Int {
        return if isCorrect {
            getPointsForCorrectResponse(question.level)
        } else {
            getPointsForIncorrectResponse(question.level)
        }
    }
    
    func getPointsForIncorrectResponse(_ level: QuestionLevel) -> Int {
        switch level {
        case .I:
            return -1
        case .II:
            return -2
        case .III, .IV, .V:
            return -3
        case .VI, .VII:
            return -4
        case .VIII, .IX:
            return -5
        case .X:
            return -6
        case .XI:
            return -7
        case .XII:
            return -8
        case .XIII:
            return -9
        }
    }

    func getPointsForCorrectResponse(_ level: QuestionLevel) -> Int {
        switch level {
        case .I, .II:
            return 5
        case .III, .IV, .V:
            return 6
        case .VI, .VII:
            return 7
        case .VIII, .IX:
            return 8
        case .X:
            return 9
        case .XI:
            return 10
        case .XII:
            return 11
        case .XIII:
            return 12
        }
    }
    
    func getTotalScore() -> Int {
        return appStorageUseCase.getTotalScore()
    }
    
    func getAllTriviaFlags() -> [TriviaFlag] {
        return gameUseCase.getAllTriviaFlags()
    }
    
    private func resetScore() {
        appStorageUseCase.resetScore()
    }
    
    func saveNewRecord(flag: TriviaFlag?, name: String) {
        if let countryId = flag?.id {
            firebaseUseCase.saveNewRecord(score: getTotalScore(), name: name, countryId: countryId.rawValue)
            resetScore()
        }
    }
}
