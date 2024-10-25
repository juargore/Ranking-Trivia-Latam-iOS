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
    var duration: Double = 0.5
    var pulseFraction: CGFloat = 1.1
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(flag.isClicked ? Color.appCustomGreen.opacity(0.9) : Color.gray)
            .frame(width: 120, height: 110)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 2)
            )
            .overlay {
                VStack {
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
            .scaleEffect(scale)
            .onChange(of: flag) { new in
                if new.isClicked {
                    withAnimation(
                        Animation.easeInOut(duration: duration)
                            .repeatForever(autoreverses: true)
                    ) {
                        scale = pulseFraction
                    }
                } else {
                    // remove animation
                    withAnimation(
                        Animation.easeInOut(duration: duration)
                    ) {
                        scale = 1.0
                    }
                }
            }
    }
}


struct CardEmptySpace: View {
    
    let index: Int
    let emptySpace: EmptySpace
    let viewModel: PlayViewModel
    
    var body: some View {
        HStack {
            let icon: String? = {
                switch index {
                case 0: return "ic_medal_gold"
                case 1: return "ic_medal_silver"
                case 2: return "ic_medal_bronze"
                default: return nil
                }
            }()
            
            if icon != nil {
                Image(icon!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                            
                    }
                    .background(Color.appCustomBlue.opacity(0.4))
                    .cornerRadius(10)
            } else {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.black.opacity(0.005))
            }
            
            RoundedRectangle(cornerRadius: 12)
                .fill(emptySpace.flagIsOver ? Color.red : Color.white)
                .frame(width: 120, height: 110)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black, lineWidth: 2)
                ).overlay {
                    VStack {
                        if emptySpace.flag == nil {
                            Text("\(index + 1)°")
                                .font(.custom("FredokaCondensed-Bold", size: 28))
                                .shadow(color: .gray, radius: 1, x: 1, y: 1)
                                .foregroundColor(.gray).opacity(0.5)
                        } else {
                            let mFlag = TriviaFlag(
                                id: emptySpace.flag!.id,
                                name: emptySpace.flag!.name,
                                image: emptySpace.flag!.image,
                                isClicked: false,
                                isEnable: false
                            )
                            CardFlag(flag: mFlag)
                        }
                    }
                }
            
            
            if emptySpace.flag != nil {
                Image("ic_remove_filled")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    .onTapGesture {
                        if viewModel.shouldPlaySound() {
                            Ranking_Trivia_Latam.playSound("sound_remove")
                        }
                        viewModel.addFlagToList(flag: emptySpace.flag!)
                        viewModel.updateEmptySpace(emptySpaceId: emptySpace.id, flag: nil)
                    }
            } else {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.black.opacity(0.005))
            }
        }
    }
}


#Preview {
    CardEmptySpace(
        index: 0,
        emptySpace: EmptySpace(id: 0, flag: nil),
        viewModel: PlayViewModel()
    )
}
