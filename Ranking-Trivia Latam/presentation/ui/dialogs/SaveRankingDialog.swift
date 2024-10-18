//
//  SaveRankingDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct ScoreUI: View {
    
    let score: Int
    let sizes: [CGFloat] = [20, 26, 30, 26, 20]
    
    var scoreString: String {
        NumberFormatter.localizedString(from: NSNumber(value: score), number: .decimal)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red.opacity(0.9))
                .frame(width: 55, height: 55)
                .onTapGesture {
                    //onClick()
                }
                .overlay {
                    Image("ic_border_circled_button")
                        .resizable()
                        .padding(.leading, 30)
                        .padding(.top, 30)
                        .frame(width: 120, height: 120)
                }
            
            HStack(spacing: 0) {
                ForEach(Array(scoreString.enumerated()), id: \.offset) { index, char in
                    let fontSize = sizes[index % sizes.count]
                    Text(String(char))
                        .font(.custom("FredokaCondensed-Semibold", size: fontSize))
                        .shadow(color: .gray, radius: 1, x: 1, y: 1)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(height: 60)
    }
}

struct ScoreUI_Previews: PreviewProvider {
    static var previews: some View {
        ScoreUI(score: 1234)
    }
}
