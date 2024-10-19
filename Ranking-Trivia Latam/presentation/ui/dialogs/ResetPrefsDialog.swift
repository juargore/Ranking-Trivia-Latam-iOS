//
//  ResetPrefsDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import SwiftUI

struct ResetPrefsDialog: View {
    
    var onResetClicked: () -> Void
    
    var body: some View {
        BaseDialog(
            titleWidth: 250,
            title: "Juego completado",
            content: {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Image("ic_info")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 5)
                        
                        Spacer(minLength: 10)
                        
                        Text(NSLocalizedString("reset_prefs_description", comment: ""))
                            .font(.custom("FredokaCondensed-Semibold", size: 20))
                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)

                        Spacer().frame(height: 35)

                        
                        ButtonExitOrRetry(
                            onClick: onResetClicked,
                            content: {
                                Text("Comenzar nueva partida")
                                    .font(.custom("FredokaCondensed-Semibold", size: 22))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 16)
                            }
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                }
                .frame(height: 300)
            }
        )
    }
}
