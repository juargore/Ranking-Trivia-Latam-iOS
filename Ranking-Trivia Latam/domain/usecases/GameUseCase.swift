//
//  GameUseCase.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation

class GameUseCase {
    
    private let gameRepository = GameRepositoryImpl()
    
    func getNextQuestionLevel(currentLevel: QuestionLevel) -> QuestionLevel? {
        return gameRepository.getNextQuestionLevel(currentLevel: currentLevel)
    }

    func getQuestionById(id: Int) -> Question {
        return gameRepository.getQuestionById(id: id)
    }
    
    func getQuestionByLevelAndExcludeTheOnesAlreadyPlayed(level: QuestionLevel, idsAlreadyPlayedByLevel: [Int]) -> Question? {
        return gameRepository.getQuestionByLevelAndExcludeTheOnesAlreadyPlayed(level, idsAlreadyPlayedByLevel)
    }
            
    func getFlagById(flagId: FlagId) -> TriviaFlag {
        return gameRepository.getTriviaFlagById(flagId: flagId)
    }
            
    func getAllTriviaFlags() -> [TriviaFlag] {
        return gameRepository.getAllTriviaFlags()
    }

    func getEmptySpacesByLevel(level: QuestionLevel) -> [EmptySpace] {
        return gameRepository.getEmptySpacesByLevel(level: level)
    }

    func verifyIfListIsCorrect(userResponse: [FlagId], question: Question) -> Bool {
        return gameRepository.verifyIfListIsCorrect(userResponse: userResponse, question: question)
    }
    
}
