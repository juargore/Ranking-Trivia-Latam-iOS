//
//  Ranking.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation

struct Ranking: FirebaseModel, Codable, Hashable {
    var id: String?
    let position: Int?
    let country_id: String
    let user_name: String
    let score: Int
    var flag: TriviaFlag?
    
    
    init(id: String? = nil, position: Int?, country_id: String = "", user_name: String = "", score: Int = 0, flag: TriviaFlag? = nil) {
        self.id = id
        self.position = position
        self.country_id = country_id
        self.user_name = user_name
        self.score = score
        self.flag = flag
    }
}
