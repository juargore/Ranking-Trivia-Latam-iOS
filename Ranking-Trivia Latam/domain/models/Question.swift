//
//  Question.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation

struct Question: Codable, Hashable {
    let id: Int
    let level: QuestionLevel  // indicates the level where this question should be placed on game
    let description: String   // question to show at the top header
    let answerFlags: [FlagId] // correct answers ordered by position
    var gameFlags: [FlagId]?  // correct answers ordered by position + random flags according to level
}
