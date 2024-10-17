//
//  CardsHall.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/14/24.
//

import Foundation
import SwiftUI


struct RankingCard: View {
    
    let ranking: Ranking

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                // Posición
                Text(String(ranking.position ?? 0))
                    .font(.custom("FredokaCondensed-Medium", size: 18))
                    .shadow(color: .gray, radius: 1, x: 2, y: 2)
                    .foregroundColor(Color.white)
                    .frame(width: geometry.size.width * 0.10)
                
                // Bandera
                if let imageName = ranking.flag?.image {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .frame(width: geometry.size.width * 0.15)
                }
                
                // Nombre del usuario
                Text(ranking.user_name)
                    .font(.custom("FredokaCondensed-Medium", size: 20))
                    .shadow(color: .gray, radius: 1, x: 2, y: 2)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .shadow(color: .gray.opacity(0.6), radius: 2, x: 0, y: 1)
                    .frame(width: geometry.size.width * 0.60)
                
                // Puntuación
                Text("\(ranking.score, format: .number)")
                    .font(.custom("FredokaCondensed-Medium", size: 18))
                    .shadow(color: .gray, radius: 1, x: 2, y: 2)
                    .foregroundColor(.white)
                    .shadow(color: .gray.opacity(0.6), radius: 2, x: 0, y: 1)
                    .frame(width: geometry.size.width * 0.15)
            }
        }
        .padding(.vertical, 12)
        //.frame(height: 50)
        
    }
}

#Preview {
    RankingCard(
        ranking: Ranking(id: "0")
    )
}
