//
//  Screen+Extension.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/18/24.
//

import SwiftUI
import Foundation
import Network

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

func checkInternetConnection(isConnected: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    isConnected(true)
                } else {
                    isConnected(false)
                }
            }
        }
        monitor.start(queue: queue)
    }
