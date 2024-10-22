//
//  Animations.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/14/24.
//

import Foundation
import SwiftUI


struct Pulsating<Content: View>: View {
    
    var duration: Double
    var pulseFraction: CGFloat
    var content: () -> Content
    
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        content()
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: duration)
                        .repeatForever(autoreverses: true)
                ) {
                    scale = pulseFraction
                }
            }
    }
}
