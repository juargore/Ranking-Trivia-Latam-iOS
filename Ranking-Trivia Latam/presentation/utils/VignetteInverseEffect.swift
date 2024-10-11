//
//  VignetteInverseEffect.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/11/24.
//

import SwiftUI

struct VignetteInverseEffect: View {
    var body: some View {
        GeometryReader { geometry in
            let canvasWidth = geometry.size.width
            let canvasHeight = geometry.size.height
            let radius = sqrt(canvasWidth * canvasWidth + canvasHeight * canvasHeight) / 2
            
            Canvas { context, size in
                let centerColor = Color.black.opacity(0.7) // Color del centro
                let edgeColor = Color.white.opacity(0.2)   // Color de los bordes
                
                let gradient = Gradient(colors: [centerColor, edgeColor])
                let startPoint = CGPoint(x: canvasWidth / 2, y: canvasHeight / 2)
                
                context.fill(
                    Path { path in
                        path.addRect(CGRect(origin: .zero, size: size))
                    },
                    with: .radialGradient(
                        gradient,
                        center: startPoint,
                        startRadius: 0,
                        endRadius: radius
                    )
                )
            }
            .ignoresSafeArea() // O usa un .modifier si quieres controlar esto
        }
    }
}
