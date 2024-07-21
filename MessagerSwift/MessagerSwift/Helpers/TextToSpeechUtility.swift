//
//  TextToSpeechUtility.swift
//  MessagerSwift
//
//  Created by Roman Rybachenko on 21.07.24.
//

import Foundation
import AVFoundation

class TextToSpeechUtility: NSObject, AVSpeechSynthesizerDelegate {
     
    let synthesizer = AVSpeechSynthesizer()
    let audioSession = AVAudioSession.sharedInstance()
    let defaultLanguage = "en-US"
    var lastPlayingUtterance: AVSpeechUtterance?
     
    func synthesizeSpeech(forText text: String?) {
        guard let text = text, !text.isEmpty else { return }
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, options: [.duckOthers])
            try audioSession.setActive(true)
        } catch let error {
            print("audioSession.setActive error: \n\(error)")
            return
        }
         
        let utterance = AVSpeechUtterance(string:text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.volume = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: detectLanguageFromText(text))
        self.synthesizer.speak(utterance)
         
        self.lastPlayingUtterance = utterance
    }
     
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (synthesizer == self.synthesizer && self.lastPlayingUtterance == utterance) {
            do {
                // after last utterance has played - deactivate the audio session
                try self.audioSession.setActive(false);
            } catch {
                return
            }
        }
    }
     
    private func detectLanguageFromText(_ text: String) -> String {
        let tagger = NSLinguisticTagger.init(tagSchemes: [NSLinguisticTagScheme.language], options: 0)
        tagger.string = text
        let textLanguage = tagger.tag(at: 0, scheme: NSLinguisticTagScheme.language, tokenRange: nil, sentenceRange: nil)
        var detectedLanguage: String?
        for installedLanguage in AVSpeechSynthesisVoice.speechVoices() {
            let languageStringParts = installedLanguage.language.components(separatedBy: "-")
            if let language = textLanguage,
               (languageStringParts.count > 0 && languageStringParts[0] == language.rawValue)
            {
                detectedLanguage = installedLanguage.language
                break
            }
        }
         
        // if language could not be detected return default language
        return detectedLanguage ?? defaultLanguage
    }
}
