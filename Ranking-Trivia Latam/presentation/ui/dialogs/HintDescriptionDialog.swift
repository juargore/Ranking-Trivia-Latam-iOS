//
//  HintDescriptionDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/29/24.
//

import SwiftUI
import Foundation

struct HintDescriptionDialog: View {
    
    var onAcceptClicked: (Bool) -> Void
    var onCancelClicked: () -> Void
    
    @State private var checkedState: Bool = false
    
    var body: some View {
        BaseDialog(
            titleWidth: 150,
            title: NSLocalizedString("hint_title", comment: ""),
            content: {
                VStack {
                    Image("ic_bulb")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.bottom, 5)
                    
                    Spacer(minLength: 15)
                    
                    Text(LocalizedStringKey("hint_description"))
                        .font(.custom("FredokaCondensed-Bold", size: 22))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 1, x: 0, y: 1)
                        .padding(.trailing, 30)
                    
                    Spacer(minLength: 15)
                    
                    Toggle(
                        isOn: $checkedState
                    ) {
                        HStack {
                            Spacer()
                            
                            Text(LocalizedStringKey("hint_checkbox"))
                                .font(.custom("FredokaCondensed-Bold", size: 20))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1, x: 0, y: 1)
                        }
                    }
                    
                    Spacer(minLength: 30)
                    
                    HStack {
                        ButtonExitOrRetry(
                            onClick: { onCancelClicked() },
                            content: {
                                Text(LocalizedStringKey("general_cancel"))
                                    .font(.custom("FredokaCondensed-Semibold", size: 22))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 16)
                            }
                        )
                        ButtonExitOrRetry(
                            onClick: { onAcceptClicked(checkedState) },
                            content: {
                                Text(LocalizedStringKey("general_accept"))
                                    .font(.custom("FredokaCondensed-Semibold", size: 22))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 16)
                            }
                        )
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 310)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
        )
    }
}

#Preview {
    HintDescriptionDialog(
        onAcceptClicked: { show in
        },
        onCancelClicked: {
            
        }
    )
}
