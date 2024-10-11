//
//  HallOfFameViewModel.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import Combine
import SwiftUI

final class HallOfFameViewModel: ObservableObject {
    
    private let firebaseUseCase = FirebaseUseCase()
    private let appStorageUseCase = AppStorageUseCase()
    private let gameUseCase = GameUseCase()
    private var disposables = Set<AnyCancellable>()
    
    @Published var ranking: [Ranking] = []
    
    public init() {
        getTop20RankingList()
    }
    
    private func getTop20RankingList() {
        firebaseUseCase
            .getTop20RankingList()
            .sink { _ in } receiveValue: { [weak self] list in
                var updatedList: [Ranking] = []
                
                for item in list {
                    var mutableItem = item
                    if let flagId = getFlagId(flagCode: item.country_id) {
                        mutableItem.flag = self?.gameUseCase.getFlagById(flagId: flagId)
                    }
                    updatedList.append(mutableItem)
                }
                
                self?.ranking = updatedList
            }.store(in: &disposables)
    }
}
