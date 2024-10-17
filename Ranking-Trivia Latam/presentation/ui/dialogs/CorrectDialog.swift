//
//  CorrectDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct CorrectDialog: View {
    
    var isVisible: Bool
    var onNextClicked: () -> Void

    var body: some View {
        if isVisible {
            BaseDialog(
                titleWidth: 160,
                title: "Correcto!",
                content: {
                    VStack(alignment: .center) {
                        Image("ic_correct")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 5)

                        Text("Excelente trabajo! Lo estás haciendo muy bien!!.\n\nPasemos a algo más retador!")
                            .font(.custom("FredokaCondensed-Semibold", size: 22))
                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)

                        Spacer().frame(height: 40)

                        HStack {
                            Spacer()
                            ButtonExitOrRetry(
                                onClick: onNextClicked,
                                content: {
                                    Text("Siguiente")
                                        .font(.custom("FredokaCondensed-Semibold", size: 24))
                                        .shadow(color: .gray, radius: 1, x: 1, y: 1)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 20)
                                }
                            )
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            )
        }
    }
}

#Preview {
    CorrectDialog(
        isVisible: true,
        onNextClicked: {
            
        }
    )
}
