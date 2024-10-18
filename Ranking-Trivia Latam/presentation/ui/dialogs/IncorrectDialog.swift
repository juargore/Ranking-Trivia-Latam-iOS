//
//  IncorrectDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct IncorrectDialog: View {
    
    var isVisible: Bool
    var onRetryClicked: () -> Void

    var body: some View {
        if isVisible {
            BaseDialog(
                titleWidth: 190,
                title: "Incorrecto!",
                content: {
                    VStack(alignment: .center) {
                        Image("ic_error")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 5)

                        Text("Haz ordenado de forma incorrecta el ranking de las banderas.\nPero no te preocupes, estás muy cerca de lograrlo!!\n\nInténtalo nuevamente!")
                            .font(.custom("FredokaCondensed-Semibold", size: 22))
                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)

                        Spacer().frame(height: 40)

                        HStack {
                            Spacer()
                            ButtonExitOrRetry(
                                onClick: onRetryClicked,
                                content: {
                                    Text("Reintentar")
                                        .font(.custom("FredokaCondensed-Semibold", size: 24))
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
    IncorrectDialog(
        isVisible: true,
        onRetryClicked: {
            
        }
    )
}
