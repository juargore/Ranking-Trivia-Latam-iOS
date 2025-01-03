//
//  TutorialDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct TutorialDialog: View {
    
    var onExitClicked: () -> Void
    
    var body: some View {
        BaseDialog(
            titleWidth: 150,
            title: NSLocalizedString("tutorial_title", comment: ""),
            content: {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Image("ic_question")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 5)
                        
                        Spacer(minLength: 10)
                        
                        Text(LocalizedStringKey("tutorial_description_top"))
                            .font(.custom("FredokaCondensed-Semibold", size: 15))
                            .foregroundColor(.black.opacity(0.7))
                        
                        VideoPlayerView(videoName: "tutorial_drag_and_drop")
                        
                        Text(LocalizedStringKey("tutorial_description_bottom"))
                            .font(.custom("FredokaCondensed-Semibold", size: 15))
                            .foregroundColor(.black.opacity(0.7))
                        
                        VideoPlayerView(videoName: "tutorial_correct_incorrect")
                        
                        Text(LocalizedStringKey("tutorial_description_final"))
                            .font(.custom("FredokaCondensed-Semibold", size: 15))
                            .foregroundColor(.black.opacity(0.7))
                        
                        Spacer(minLength: 35)
                        
                        ButtonExitOrRetry(
                            onClick: onExitClicked,
                            content: {
                                Text(LocalizedStringKey("general_exit"))
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
                .frame(height: 550)
            }
        )
    }
}

#Preview {
    TutorialDialog(onExitClicked: {})
}
