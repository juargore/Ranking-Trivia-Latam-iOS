//
//  ISharedPrefsRepository.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation

protocol IAppStorageManager {
    
    func saveQuestionAlreadyPlayed(question: Question)

    func getLastQuestionIdPlayed() -> Int

    func getIdsOfQuestionsAlreadyPlayedByQuestionLevel(level: QuestionLevel) -> [Int]

    func saveEnableSound(enable: Bool)

    func getIsSoundEnabled() -> Bool

    func incrementCounterOfErrors()

    func getTotalErrors() -> Int

    func resetErrors()

    func incrementScore(points: Int)

    func getTotalScore() -> Int

    func resetScore()

    func setUserCompletedGame()

    func getUserCompletedGame() -> Bool

    func resetAllData()
    
    func saveShowHintDialog(show: Bool)

    func getShowHintDialog() -> Bool
    
}
