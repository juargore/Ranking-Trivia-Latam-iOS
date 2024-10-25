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
                title: NSLocalizedString("correct_title", comment: ""),
                content: {
                    VStack(alignment: .center) {
                        Image("ic_correct")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 5)

                        Text(NSLocalizedString("correct_description", comment: ""))
                            .font(.custom("FredokaCondensed-Semibold", size: 22))
                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)

                        Spacer().frame(height: 40)

                        HStack {
                            Spacer()
                            ButtonExitOrRetry(
                                onClick: onNextClicked,
                                content: {
                                    Text(NSLocalizedString("general_next", comment: ""))
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
    CorrectDialog(
        isVisible: true,
        onNextClicked: {
            
        }
    )
}
