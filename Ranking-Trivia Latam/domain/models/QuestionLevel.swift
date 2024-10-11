//
//  QuestionLevel.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation

enum QuestionLevel: String, Hashable, Codable {
    case I
    case II
    case III
    case IV
    case V
    case VI
    case VII
    case VIII
    case IX
    case X
    case XI
    case XII
    case XIII
}

/*
    I ->    3 banderas | 3 slots | 7 turnos | 60s
    II ->   4 banderas | 3 slots | 7 turnos | 60s
    III ->  5 banderas | 3 slots | 7 turnos | 60s
    IV ->   5 banderas | 4 slots | 7 turnos | 60s

    V ->    6 banderas | 6 slots | 8 turnos | 50s
    VI ->   6 banderas | 5 slots | 7 turnos | 50s
    VII ->  6 banderas | 4 slots | 7 turnos | 50s
    VIII -> 6 banderas | 3 slots | 7 turnos | 45s

    IX ->   6 banderas | 3 slots | 1 blur | 8 turnos | 45s
    X ->    6 banderas | 4 slots | 1 blur | 7 turnos | 45s

    XI ->   6 banderas | 4 slots | 2 blur | 7 turnos | 40s
    XII ->  6 banderas | 3 slots | 2 blur | 8 turnos | 30s
    XIII -> 6 banderas | 3 slots | 3 blur | 8 turnos | 20s
*/
