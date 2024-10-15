//
//  Cards.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import SwiftUI

struct CardFlag: View {
    
    let flag: TriviaFlag
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(flag.alreadyPlayed ? Color.clear : Color.appCustomGreen.opacity(0.5))
                .frame(width: 120, height: 110)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 2)
                )
            
            VStack {
                if !flag.alreadyPlayed {
                    if let uiImage = flag.loadImage() {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 0.8)
                            )
                    }
                    
                    Text(flag.name)
                        .multilineTextAlignment(.center)
                        .font(.custom("FredokaCondensed-Bold", size: 18))
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding(.top, 2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CardFlag(flag: TriviaFlag(
        id: .MX,
        name: NSLocalizedString("country_name_mexico", comment: ""),
        image: "flag_mexico",
        alreadyPlayed: false)
    )
}


struct CardEmptySpace: View {
    
    let index: Int
    let emptySpace: EmptySpace
    //let viewModel: PlayViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: 120, height: 110)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 1)
                )
            
            VStack {
                if emptySpace.flag == nil {
                    Text("\(index + 1)°")
                        .font(.custom("FredokaCondensed-Bold", size: 28))
                        .shadow(color: .gray, radius: 1, x: 1, y: 1)
                        .foregroundColor(.gray).opacity(0.5)
                } else {
                    CardFlag(flag: emptySpace.flag!)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    CardEmptySpace(
        index: 0,
        emptySpace: EmptySpace(id: 0, flag: nil)
    )
}
