//
//  ViewsHall.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/14/24.
//

import Foundation
import SwiftUI

struct HeaderBackAndCategory: View {
    
    var viewModel: PlayViewModel
    var onBack: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                if viewModel.shouldPlaySound() {
                    Ranking_Trivia_Latam.playSound("sound_click")
                }
                onBack()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                    Image("ic_back")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 20)
                }
            }
            Spacer()
            Image("logo_no_background_letters")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 30)
        }
    }
}
