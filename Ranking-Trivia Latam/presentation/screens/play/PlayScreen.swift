//
//  PlayScreen.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import Foundation
import SwiftUI

struct PlayScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            PlayBackground()
            
            VStack {
                HeaderBackAndCategory {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal, 196)

        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct PlayBackground: View {
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(named: "pyramid_one")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VignetteInverseEffect()
            
            /*
             AdmobBanner(
             modifier = modifierAdmob,
             adId = HOME_BOTTOM_SMALL_BANNER_ID
             )
             */
        }
    }
}

#Preview {
    PlayScreen()
}
