//
//  HomeScreen.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI

struct HomeScreen: View {
    
    var body: some View {
        ZStack {
            HomeBackground()
        }
    }
}

struct HomeBackground: View {
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(named: "pyramid_main_screen")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VignetteInverseEffect()
            
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
               let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            
                // version = 1.0
                // build = "1.0.1"
                HStack {
                    Text("v\(build)")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
                .padding(.horizontal, 200)
            }
            
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
    HomeScreen()
}
