//
//  Sounds.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/14/24.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(_ resourceName: String) {
    if let path = Bundle.main.path(forResource: resourceName, ofType: "wav") {
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error al reproducir el sonido: \(error.localizedDescription)")
        }
        
        audioPlayer?.delegate = AVAudioPlayerDelegateWrapper(onCompletion: {
            audioPlayer = nil
        })
    }
}

class AVAudioPlayerDelegateWrapper: NSObject, AVAudioPlayerDelegate {
    var onCompletion: (() -> Void)?

    init(onCompletion: (() -> Void)?) {
        self.onCompletion = onCompletion
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        onCompletion?()
    }
}
