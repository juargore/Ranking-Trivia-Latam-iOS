//
//  TimeUpDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct TimeUpDialog: View {
    
    var isVisible: Bool
    var onRetryClicked: () -> Void

    var body: some View {
        if isVisible {
            BaseDialog(
                titleWidth: 260,
                title: "¡Se terminó el tiempo!",
                content: {
                    VStack(alignment: .center) {
                        Image("ic_clock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 5)

                        Text("Necesitas apresurarte para lograr acomodar correctamente las banderas en el orden correcto.\n\n¡Venga! Tú puedes!!")
                            .font(.custom("FredokaCondensed-Semibold", size: 22))
                            .shadow(color: .gray, radius: 1, x: 1, y: 1)
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

struct ButtonExitOrRetry<Content: View>: View {
    
    var onClick: () -> Void
    var content: () -> Content

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.AppYellow)
                .frame(width: 150, height: 50)
                .shadow(radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.black, lineWidth: 4)
                )
                .onTapGesture {
                    onClick()
                }

            content()
        }
    }
}

#Preview {
    TimeUpDialog(
        isVisible: true,
        onRetryClicked: {
            
        }
    )
}
