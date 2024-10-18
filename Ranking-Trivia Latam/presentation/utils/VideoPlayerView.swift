//
//  VideoPlayer.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/17/24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    let videoName: String
    
    @State private var player: AVPlayer? = nil
    
    var body: some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .frame(height: 250)
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        player.pause()
                        player.seek(to: .zero)
                    }
            } else {
                Text("Error loading video")
            }
        }
        .onAppear {
            if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
                let url = URL(fileURLWithPath: path)
                player = AVPlayer(url: url)
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(videoName: "tutorial_correct_incorrect")
    }
}
