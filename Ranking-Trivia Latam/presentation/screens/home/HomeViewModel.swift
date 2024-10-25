//
//  HomeViewModel.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import Combine
import SwiftUI

final class HomeViewModel: ObservableObject {
    
    private let firebaseUseCase = FirebaseUseCase()
    private let appStorageUseCase = AppStorageUseCase()
    private var disposables = Set<AnyCancellable>()
    
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        let currentLanguage = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
        self.selectedLanguage = currentLanguage
    }
    
    func gameHasNewerVersion(currentVersion: Int, onResponse: @escaping (Bool) -> Void ) {
        firebaseUseCase
            .gameHasNewerVersion(currentVersion: currentVersion)
            .sink { _ in} receiveValue: { response in
                onResponse(response)
            }.store(in: &disposables)
    }
    
    func saveEnableSound(enable: Bool) {
        appStorageUseCase.saveEnableSound(enable: enable)
    }
    
    func shouldPlaySound() -> Bool {
        //print("AQUI: shouldPlaySound: \(appStorageUseCase.getIsSoundEnabled())")
        return appStorageUseCase.getIsSoundEnabled()
    }
    
    func userCompletedGame() -> Bool {
        return appStorageUseCase.getUserCompletedGame()
    }
    
    func resetAllData() {
        appStorageUseCase.resetAllData()
    }
    
    func getInitialOptionForRB() -> String {
        let mLanguage: String = {
            switch selectedLanguage {
            case "en": return NSLocalizedString("options_english", comment: "")
            case "pt-BR": return NSLocalizedString("options_portuguese", comment: "")
            default: return NSLocalizedString("options_spanish", comment: "")
            }
        }()
        return mLanguage
    }
}
