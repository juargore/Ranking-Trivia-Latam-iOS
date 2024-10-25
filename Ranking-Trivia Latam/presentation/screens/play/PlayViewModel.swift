//
//  PlayViewModel.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import Combine
import SwiftUI

final class PlayViewModel: ObservableObject {
 
    private let gameUseCase = GameUseCase()
    private let appStorageUseCase = AppStorageUseCase()
    private var disposables = Set<AnyCancellable>()
    
    @Published var timePerLevel: Double = 0
    @Published var gameCompleted: Bool = false
    @Published var question: Question? = nil
    @Published var flags: [TriviaFlag] = []
    @Published var spaces: [EmptySpace] = []
    
    func resetTime() {
        timePerLevel = 0.0
    }
    
    func resetScreenData(getNewQuestion: Bool) {
        timePerLevel = 0
        question = nil
        flags = []
        spaces = []
        
        if getNewQuestion {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 0.1 second delay
                self.getQuestionToPlay()
            }
        }
    }
    
    func getQuestionToPlay() {
        //print("AQUI: Entro a getQuestionToPlay()")
        let lastQuestionIdPlayed: Int = appStorageUseCase.getLastQuestionIdPlayed() // questionId (Int) or -1
        if lastQuestionIdPlayed > 0 {
            let lastQuestionPlayed: Question = gameUseCase.getQuestionById(id: lastQuestionIdPlayed)
            let idsAlreadyPlayedByLevel: [Int] = appStorageUseCase.getIdsOfQuestionsAlreadyPlayedByQuestionLevel(level: lastQuestionPlayed.level)
            let nextQuestion: Question? = gameUseCase.getQuestionByLevelAndExcludeTheOnesAlreadyPlayed(level: lastQuestionPlayed.level, idsAlreadyPlayedByLevel: idsAlreadyPlayedByLevel)
            if nextQuestion != nil {
                // at this level, there are still pending questions
                question = nextQuestion
                getEmptySpacesByLevel(nextQuestion!)
            } else {
                // the level is complete -> continue to next level if exists
                print("AQUI: the level is complete -> continue to next level if exists")
                let nextLevel: QuestionLevel? = gameUseCase.getNextQuestionLevel(currentLevel: lastQuestionPlayed.level)
                if nextLevel == nil {
                    // no more levels available -> user has completed the game!!
                    print("AQUI: no more levels available -> user has completed the game!!")
                    gameCompleted = true
                } else {
                    // there are still pending levels -> get the first random question of nextLevel
                    print("AQUI: there are still pending levels -> get the first random question of nextLevel")
                    let newQuestion: Question? = gameUseCase.getQuestionByLevelAndExcludeTheOnesAlreadyPlayed(level: nextLevel!, idsAlreadyPlayedByLevel: [])
                    question = newQuestion
                    if newQuestion != nil {
                        getEmptySpacesByLevel(newQuestion!)
                    }
                }
            }
        } else {
            // no question stored in shared preferences -> user just started to play!
            print("AQUI: no question stored in shared preferences -> user just started to play!")
            let newQuestion: Question? = gameUseCase.getQuestionByLevelAndExcludeTheOnesAlreadyPlayed(level: QuestionLevel.I, idsAlreadyPlayedByLevel: [])
            question = newQuestion
            if newQuestion != nil {
                getEmptySpacesByLevel(newQuestion!)
            }
        }
    }
    
    private func getEmptySpacesByLevel(_ question: Question) {
        spaces = gameUseCase.getEmptySpacesByLevel(level: question.level)
        //print("AQUI: TotalSpaces: \(spaces.count)")
        getFlagsByQuestion(question)
    }
    
    private func getFlagsByQuestion(_ question: Question) {
        var mQuestions: [TriviaFlag] = []
        for gameFlag in question.gameFlags! {
            let flag: TriviaFlag = gameUseCase.getFlagById(flagId: gameFlag)
            mQuestions.append(flag)
        }
        flags = mQuestions
        getTimePerLevel(question)
        //print("AQUI: TotalFlags: \(flags.count)")
    }
    
    private func getTimePerLevel(_ question: Question) {
        timePerLevel = getTimeAccordingLevel(level: question.level)
    }
    
    func verifyIfListIsCorrect(userResponse: [FlagId], question: Question) -> Bool {
        return gameUseCase.verifyIfListIsCorrect(userResponse: userResponse, question: question)
    }
    
    func updateEmptySpace(emptySpaceId: Int, flag: TriviaFlag?) {
        spaces = spaces.map { space in
            if space.id == emptySpaceId {
                return EmptySpace(id: space.id, flag: flag)
            } else {
                return space
            }
        }
    }
    
    func removeFlagFromList(flag: TriviaFlag) {
        flags = flags.map { f in
            if f == flag {
                return TriviaFlag(id: flag.id, name: flag.name, image: flag.image, alreadyPlayed: true)
            } else {
                return f
            }
        }
    }
    
    func addFlagToList(flag: TriviaFlag) {
        flags = flags.map { f in
            if f.id == flag.id {
                return TriviaFlag(id: flag.id, name: flag.name, image: flag.image, alreadyPlayed: false)
            } else {
                return f
            }
        }
    }
    
    func isThisFlagAlreadyUsed(flag: TriviaFlag) -> Bool {
        return spaces.contains { $0.flag?.id == flag.id }
    }
    
    func saveQuestionAlreadyPlayed(question: Question?) {
        if question != nil {
            // print("AQUI: Se guarda \(question.id) como útlima jugada")
            appStorageUseCase.saveQuestionAlreadyPlayed(question: question!)
        }
    }
    
    func shouldPlaySound() -> Bool {
        return appStorageUseCase.getIsSoundEnabled()
    }
    
    func incrementCounterOfErrors() {
        appStorageUseCase.incrementCounterOfErrors()
    }
    
    func shouldDisplayAd() -> Bool {
        let totalErrors = appStorageUseCase.getTotalErrors()
        //print("AQUI: TotalErrors stored = \(totalErrors)")
        return totalErrors >= 4
    }
    
    func shouldDisplayAdAtStart() -> Bool {
        let totalErrors = appStorageUseCase.getTotalErrors()
        //print("AQUI: TotalErrors stored max = \(totalErrors)")
        return totalErrors >= 6
    }
    
    func resetErrors() {
        appStorageUseCase.resetErrors()
    }
    
    func getTimeAccordingLevel(level: QuestionLevel) -> Double {
        switch level {
        case .I, .II, .III: return 60
        case .IV, .V: return 50
        case .VI, .VII: return 45
        case .VIII, .IX, .X: return 40
        case .XI: return 30
        case .XII: return 20
        case .XIII: return 15
        }
    }
}
