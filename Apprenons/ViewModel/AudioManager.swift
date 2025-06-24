//
//  AudioManager.swift
//  Apprenons
//
//  Created by Alexander Black on 10/26/24.
//

import Foundation
import AVFoundation

@Observable
class AudioManager {
    public static let shared = AudioManager()
    private var audioPlayer: AVAudioPlayer?
    var isMuted: Bool = false
    
    private init() {}
        
    func playSound(named fileName: String) {
        guard let soundURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Error: Could not find sound file.")
            return
        }
            
        do {
            if audioPlayer?.isPlaying == true {
                audioPlayer?.stop()
            }
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.volume = isMuted ? 0 : 1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error: Could not load sound file.")
        }
    }
}
