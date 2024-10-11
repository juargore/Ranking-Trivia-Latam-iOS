//
//  TriviaFlag.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import UIKit

struct TriviaFlag: Codable, Hashable {
    let id: FlagId
    let name: String
    let image: String
    var alreadyPlayed: Bool = false
    
    init(id: FlagId, name: String, image: String, alreadyPlayed: Bool = false) {
        self.id = id
        self.name = name
        self.image = image
        self.alreadyPlayed = alreadyPlayed
    }
    
    // method to load image from local resources
    func loadImage() -> UIImage? {
        return UIImage(named: image)
    }
}
