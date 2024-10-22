//
//  Sounds.swift
//  Ranking-Trivia Latam
//
//  Created by Arturo Gomez on 10/14/24.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?
var audioPlayerDelegate: AVAudioPlayerDelegateWrapper?

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
        
        audioPlayerDelegate = AVAudioPlayerDelegateWrapper(onCompletion: {
            audioPlayer = nil
        })
        
        audioPlayer?.delegate = audioPlayerDelegate
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


class SoundManager {

var audioPlayer = AVAudioPlayer()
let errorSoundFileName = "sounderror.wav"
    
@Published private(set) var soundEffectsEnabled = false
@Published private(set) var musicEnabled = false

func playError() {
    
let path = Bundle.main.path(forResource: errorSoundFileName, ofType: nil)!
let url = URL(fileURLWithPath: path)

do {
audioPlayer = try AVAudioPlayer(contentsOf: url)
audioPlayer.play()
} catch {
print("SoundManager.playHintSolved couldn't play")
fatalError("Coudln't play file")
}//catch
}//func

}//class
