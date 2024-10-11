//
//  Settings.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation

struct AndroidBuildVersion: FirebaseModel, Codable, Hashable {
    var id: String?
    let android_build_number: Int

    init(id: String? = nil, android_build_number: Int = 0) {
        self.id = id
        self.android_build_number = android_build_number
    }
}
