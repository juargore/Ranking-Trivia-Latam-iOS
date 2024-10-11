//
//  SharedPrefsRepositoryImpl.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

public enum StorageKeys: String {
    case listOfIdsAlreadyPlayed = "list_of_ids_already_played"
    case lastQuestionPlayed = "last_question_played"
    case enableSound = "enable_sound"
    case totalErrors = "total_errors"
    case totalScore = "total_score"
    case gameCompleted = "game_completed"
}

public protocol AppStorageManagerProtocol: AnyObject {
    func storeValue<T: Encodable>(_ value: T, for key: StorageKeys)
    func getValue<T: Decodable>(model: T.Type, for key: StorageKeys) -> T?
}


final public class AppStorageManager: AppStorageManagerProtocol, IAppStorageManager {
    
    public init() {
        
    }
    
    func saveQuestionAlreadyPlayed(question: Question) {
        var listIdsAlreadyPlayed = getValue(model: [Int].self, for: .listOfIdsAlreadyPlayed) ?? []
                
        if !listIdsAlreadyPlayed.contains(question.id) {
            listIdsAlreadyPlayed.append(question.id)
        }
        
        storeValue(listIdsAlreadyPlayed, for: .listOfIdsAlreadyPlayed)
        saveLastQuestionPlayed(question)
    }
    
    func saveLastQuestionPlayed(_ question: Question) {
        storeValue(question.id, for: .lastQuestionPlayed)
    }
    
    func getLastQuestionIdPlayed() -> Int {
        return getValue(model: Int.self, for: .lastQuestionPlayed) ?? -1
    }
    
    func getIdsOfQuestionsAlreadyPlayedByQuestionLevel(level: QuestionLevel) -> [Int] {
        let currentData = getValue(model: [Int].self, for: .listOfIdsAlreadyPlayed) ?? []
                
        let range: ClosedRange<Int> = {
            switch level {
            case .I: return 0...19
            case .II: return 20...29
            case .III: return 30...39
            case .IV: return 40...49
            case .V: return 50...59
            case .VI: return 60...69
            case .VII: return 70...79
            case .VIII: return 80...89
            case .IX: return 90...99
            case .X: return 100...109
            case .XI: return 110...119
            case .XII: return 120...129
            case .XIII: return 130...139
            }
        }()
        
        return currentData.filter { range.contains($0) }
    }
    
    func saveEnableSound(enable: Bool) {
        storeValue(enable, for: .enableSound)
    }
    
    func getIsSoundEnabled() -> Bool {
        return getValue(model: Bool.self, for: .enableSound) ?? true
    }
    
    func incrementCounterOfErrors() {
        let totalErrors = getTotalErrors()
        storeValue(totalErrors + 1, for: .totalErrors)
    }
    
    func getTotalErrors() -> Int {
        return getValue(model: Int.self, for: .totalErrors) ?? 0
    }
    
    func resetErrors() {
        storeValue(0, for: .totalErrors)
    }
    
    public func incrementScore(points: Int) {
        let storedScore = getTotalScore()
        storeValue(storedScore + points, for: .totalScore)
    }
    
    public func getTotalScore() -> Int {
        return getValue(model: Int.self, for: .totalScore) ?? 0
    }
    
    public func resetScore() {
        storeValue(0, for: .totalScore)
    }
    
    public func setUserCompletedGame() {
        storeValue(true, for: .gameCompleted)
    }
    
    public func getUserCompletedGame() -> Bool {
        return getValue(model: Bool.self, for: .gameCompleted) ?? false
    }
    
    public func resetAllData() {
        let keys: [StorageKeys] = [.listOfIdsAlreadyPlayed, .lastQuestionPlayed, .totalErrors, .totalScore, .gameCompleted]
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
    
    public func storeValue<T>(_ value: T, for key: StorageKeys) where T : Encodable {
        @AppStorage(key.rawValue) var keyData: Data?

        do {
            let data = try JSONEncoder().encode(value)
            keyData = data
        } catch {
            debugPrint("AppStorageManager - Failed to encode data: ", error)
        }
    }
    
    public func getValue<T>(model: T.Type, for key: StorageKeys) -> T? where T : Decodable {
        @AppStorage(key.rawValue) var data: Data?

        guard let data = data else { return nil }

        do {
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            debugPrint("AppStorageManager - Failed to decode data: ", error)
        }

        return nil
    }
}
