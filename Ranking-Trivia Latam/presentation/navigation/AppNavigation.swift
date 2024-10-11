//
//  AppNavigation.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import SwiftUI

final class AppNavigation: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case onNavigateToPlayScreen(String)
        case onNavigateToHallOfFameScreen(String)
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        try navPath.append(destination)
    }
    
    func navigateBack() {
        try navPath.removeLast()
    }
    
    func navigateToRoot() {
        try navPath.removeLast(navPath.count)
    }
}
