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
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}

enum NavigationDestination: Hashable {
    case playScreen
    case hallOfFameScreen
    case homeScreen
}
