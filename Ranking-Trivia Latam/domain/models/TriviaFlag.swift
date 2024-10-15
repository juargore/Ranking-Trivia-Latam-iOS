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

class TriviaFlag: NSObject, Codable, NSItemProviderWriting {
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

    func loadImage() -> UIImage? {
        return UIImage(named: image)
    }

    // Implementación de NSItemProviderWriting
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [UTType.text.identifier]
    }

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        if typeIdentifier == UTType.text.identifier {
            let data = name.data(using: .utf8)
            completionHandler(data, nil)
        } else {
            completionHandler(nil, NSError(domain: "Invalid type identifier", code: -1, userInfo: nil))
        }
        return nil
    }

    // Métodos hashable
    static func == (lhs: TriviaFlag, rhs: TriviaFlag) -> Bool {
        return lhs.id == rhs.id
    }

    /*func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }*/
}


/*struct TriviaFlag: Codable, Hashable {
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
}*/

/*extension TriviaFlag: NSItemProviderWriting {
    
    // Definir los identificadores de tipos compatibles para el drag & drop
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [UTType.text.identifier] // Definir el tipo que quieras usar, en este caso texto
    }
    
    // Cargar los datos para el identificador de tipo
    func loadData(forTypeIdentifier typeIdentifier: String, completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        if typeIdentifier == UTType.text.identifier {
            let data = name.data(using: .utf8) // Aquí decides qué datos del objeto usar
            completionHandler(data, nil)
        } else {
            completionHandler(nil, NSError(domain: "Invalid type identifier", code: -1, userInfo: nil))
        }
        return nil
    }
}*/

/*class TriviaFlagItemProvider: NSObject, NSItemProviderWriting {
    
    let triviaFlag: TriviaFlag

    init(triviaFlag: TriviaFlag) {
        self.triviaFlag = triviaFlag
    }

    static var writableTypeIdentifiersForItemProvider: [String] {
        return [UTType.text.identifier]
    }

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        if typeIdentifier == UTType.text.identifier {
            let data = triviaFlag.name.data(using: .utf8)
            completionHandler(data, nil)
        } else {
            completionHandler(nil, NSError(domain: "Invalid type identifier", code: -1, userInfo: nil))
        }
        return nil
    }
}*/
