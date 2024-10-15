//
//  Settings.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation

struct AndroidBuildVersion: FirebaseModel, Codable, Hashable {
    var id: String?
    let ios_build_number: Int

    init(id: String? = nil, ios_build_number: Int = 0) {
        self.id = id
        self.ios_build_number = ios_build_number
    }
}
