//
//  AnimatedScoreData.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/17/24.
//

import Foundation

struct AnimatedScoreData: Codable, Hashable {
    let visible: Bool
    let isCorrect: Bool
    let question: Question
}
