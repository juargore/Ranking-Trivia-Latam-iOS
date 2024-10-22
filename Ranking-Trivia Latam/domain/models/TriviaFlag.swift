//
//  TriviaFlag.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import UIKit
import UniformTypeIdentifiers


import UIKit
import UniformTypeIdentifiers

class TriviaFlag: NSObject, Codable {
    let id: FlagId
    let name: String
    let image: String
    var alreadyPlayed: Bool = false
    var isClicked: Bool = false
    var isEnable: Bool = true
    
    init(id: FlagId, name: String, image: String, alreadyPlayed: Bool = false, isClicked: Bool = false, isEnable: Bool = true) {
        self.id = id
        self.name = name
        self.image = image
        self.alreadyPlayed = alreadyPlayed
        self.isClicked = isClicked
        self.isEnable = isEnable
    }
    
    func loadImage() -> UIImage? {
        return UIImage(named: image)
    }
}
