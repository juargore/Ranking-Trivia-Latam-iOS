//
//  ContentView.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/9/24.
//

import SwiftUI
import SwiftSVG

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Image(uiImage: UIImage(named: "flag_belize")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 80)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
