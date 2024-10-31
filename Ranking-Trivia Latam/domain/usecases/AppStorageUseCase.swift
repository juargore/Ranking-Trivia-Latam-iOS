//
//  SharedPrefsUseCase.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation

class AppStorageUseCase {
    
    private let appStorageManager = AppStorageManager()
    
    func saveQuestionAlreadyPlayed(question: Question) {
        appStorageManager.saveQuestionAlreadyPlayed(question: question)
    }
    
    func getLastQuestionIdPlayed() -> Int {
        return appStorageManager.getLastQuestionIdPlayed()
    }
    
    func getIdsOfQuestionsAlreadyPlayedByQuestionLevel(level: QuestionLevel) -> [Int] {
        return appStorageManager.getIdsOfQuestionsAlreadyPlayedByQuestionLevel(level: level).sorted()
    }
    
    func saveEnableSound(enable: Bool) {
        appStorageManager.saveEnableSound(enable: enable)
    }
    
    func getIsSoundEnabled() -> Bool {
        return appStorageManager.getIsSoundEnabled()
    }

    func incrementCounterOfErrors() {
        appStorageManager.incrementCounterOfErrors()
    }

    func getTotalErrors() -> Int {
        return appStorageManager.getTotalErrors()
    }

    func resetErrors() {
        appStorageManager.resetErrors()
    }

    func incrementScore(points: Int) {
        appStorageManager.incrementScore(points: points)
    }

    func getTotalScore() -> Int {
        return appStorageManager.getTotalScore()
    }

    func resetScore() {
        appStorageManager.resetScore()
    }

    func getUserCompletedGame() -> Bool {
        return appStorageManager.getUserCompletedGame()
    }

    func resetAllData() {
        appStorageManager.resetAllData()
    }
    
    func saveShowHintDialog(show: Bool) {
        appStorageManager.saveShowHintDialog(show: show)
    }

    func getShowHintDialog() -> Bool {
        return appStorageManager.getShowHintDialog()
    }
}
