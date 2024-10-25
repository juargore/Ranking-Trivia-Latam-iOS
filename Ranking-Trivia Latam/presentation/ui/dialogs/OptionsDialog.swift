//
//  OptionsDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct OptionsDialog: View {
    
    var viewModel: HomeViewModel
    var onExitClicked: () -> Void
    
    @State private var soundEnabled: Bool
    
    init(
        viewModel: HomeViewModel,
        onExitClicked: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onExitClicked = onExitClicked
        self.soundEnabled = viewModel.shouldPlaySound() ? true : false
    }
    
    var body: some View {
        BaseDialog(
            titleWidth: 150,
            title: NSLocalizedString("options_title", comment: ""),
            content: {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Image("ic_settings")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .padding(.bottom, 5)
                        
                        Spacer(minLength: 10)
                        Toggle(
                            LocalizedStringKey("options_sound"),
                            isOn: $soundEnabled
                        )
                        Spacer(minLength: 40)
                        
                        HStack {
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
                            ButtonExitOrRetry(
                                onClick: {
                                    viewModel.saveEnableSound(enable: soundEnabled)
                                    onExitClicked()
                                },
                                content: {
                                    Text(LocalizedStringKey("general_save"))
                                        .font(.custom("FredokaCondensed-Semibold", size: 22))
                                        .foregroundColor(.black)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 16)
                                }
                            )
                        }
                        
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                }
                .frame(height: 200)
            }
        )
        .onAppear {
            soundEnabled = viewModel.shouldPlaySound() ? true : false
        }
    }
}


#Preview {
    OptionsDialog(
        viewModel: HomeViewModel(),
        onExitClicked: {}
    )
}
