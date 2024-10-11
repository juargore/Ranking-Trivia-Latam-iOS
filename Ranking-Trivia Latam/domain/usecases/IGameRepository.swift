//
//  IGameRepository.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation

protocol IGameRepository {
    
    func getNextQuestionLevel(currentLevel: QuestionLevel) -> QuestionLevel?
    
    func getQuestionById(id: Int) -> Question
    
    func getQuestionByLevelAndExcludeTheOnesAlreadyPlayed(_ level: QuestionLevel, _ idsAlreadyPlayedByLevel: [Int]) -> Question?
    
    func getTriviaFlagById(flagId: FlagId) -> TriviaFlag

    func getAllTriviaFlags() -> [TriviaFlag]

    func getEmptySpacesByLevel(level: QuestionLevel) -> [EmptySpace]

    func verifyIfListIsCorrect(userResponse: [FlagId], question: Question) -> Bool
    
}
