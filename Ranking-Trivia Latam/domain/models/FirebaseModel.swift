//
//  FirebaseModel.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/10/24.
//

import Foundation

protocol FirebaseModel: Codable, Hashable {
    var id: String? { get set }
}
