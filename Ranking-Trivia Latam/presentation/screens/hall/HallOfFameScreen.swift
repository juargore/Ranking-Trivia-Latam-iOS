//
//  HallOfFameScreen.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import SwiftUI

struct HallOfFameScreen: View {
    
    @ObservedObject var viewModel = HallOfFameViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showNewRankingDialog = false
    @State private var showToast = false
    @State private var messageToast = ""
    
    var body: some View {
        ZStack {
            HallOfFameBackground()
            
            VStack {
                HeaderBackAndCategory {
                    presentationMode.wrappedValue.dismiss()
                }
                
                HallOfFameTitle()
                
                VStack {
                    ScrollViewReader { scrollView in
                        ScrollView(.vertical) {
                            LazyVStack {
                                ForEach(Array(viewModel.ranking.enumerated()), id: \.offset) { i, ranking in
                                    RankingCard(ranking: Ranking(
                                        id: ranking.id,
                                        position: i + 1,
                                        country_id: ranking.country_id,
                                        user_name: ranking.user_name,
                                        score: ranking.score,
                                        flag: ranking.flag
                                    ))
                                }
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.appCustomBlue.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2)
                )
                
            }
            .padding(.horizontal, 196)
            .padding(.bottom, 60)
            
            // TODO: Delete FAB for PROD
            /*FloatingButtonV2() {
                showNewRankingDialog = true
            }*/
        }
        .toolbar(.hidden, for: .navigationBar)
        .toast(message: messageToast, isShowing: $showToast, duration: Toast.short)
        .popUpDialog(isShowing: $showNewRankingDialog, dialogContent: {
            SaveRankingDialog(
                viewModel: viewModel,
                onSavedSuccess: {
                    messageToast = "Guardando récord..."
                    showToast = true
                },
                onDismiss: {
                    showNewRankingDialog = false
                }
            )
        })
    }
}

struct HallOfFameTitle: View {
    var body: some View {
        VStack {
            Text("Salón de la Fama")
                .font(.custom("FredokaCondensed-Medium", size: 32))
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .lineSpacing(24) // lineHeight

            Text("Top 20 jugadores con mejor puntuación")
                .font(.custom("FredokaCondensed-Medium", size: 18))
                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .lineSpacing(24)
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.appCustomBlue.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 2)
        )
    }
}

struct HallOfFameBackground: View {
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(named: "pyramid_two")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VignetteInverseEffect()
            
            AdmobBanner(adUnitID: Constants.HALL_BOTTOM_SMALL_BANNER_ID)
                .frame(width: UIScreen.screenWidth - 20, height: 50)
                .frame(maxHeight: UIScreen.screenHeight, alignment: .bottom)
        }
    }
}

struct FloatingButtonV2: View {
    
    var onClick: () -> Void
    
    var body: some View {
        Button(action: { onClick() }) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 4)
                    )
                    .overlay {
                        Text("+")
                            .font(.largeTitle)
                    }
            }
        }
        .frame(width: UIScreen.screenWidth - 20, height: 50)
        .frame(maxHeight: UIScreen.screenHeight, alignment: .bottom)
        .padding(.bottom, 70)
    }
}

#Preview {
    HallOfFameScreen()
}
