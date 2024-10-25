//
//  CorrectDialog.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct RestartAppDialog: View {

    var body: some View {
        BaseDialog(
            titleWidth: 160,
            title: NSLocalizedString("home_restart_title", comment: ""),
            content: {
                VStack(alignment: .center) {

                    Text(LocalizedStringKey("home_restart_description"))
                        .font(.custom("FredokaCondensed-Semibold", size: 22))
                        .shadow(color: .black, radius: 1, x: 1, y: 1)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)

                    Spacer().frame(height: 40)

                    HStack {
                        Spacer()
                        ButtonExitOrRetry(
                            onClick: { exit(0) },
                            content: {
                                Text(LocalizedStringKey("home_restart_got_it"))
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

#Preview {
    RestartAppDialog()
}
