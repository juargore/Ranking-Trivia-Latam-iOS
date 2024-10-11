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
        return appStorageUseCase.getIsSoundEnabled()
    }
    
    func userCompletedGame() -> Bool {
        return appStorageUseCase.getUserCompletedGame()
    }
    
    func resetAllData() {
        appStorageUseCase.resetAllData()
    }
}
