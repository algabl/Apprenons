//
//  Progress.swift
//  Apprenons
//
//  Created by Alexander Black on 10/15/24.
//

import Foundation

struct Progress: Codable {
    let topicID: Int
    var lessonRead = false {
        didSet {
            saveToUserDefaults()
        }
    }
    var flashcardStudied = false {
        didSet {
            saveToUserDefaults()
        }
    }
    var quizPassed = false {
        didSet {
            saveToUserDefaults()
        }
    }
    var quizHighScore: Int? {
        didSet {
            saveToUserDefaults()
        }
    }
    
    init(topicID: Int) {
        self.topicID = topicID
        if let loadedProgress = Self.loadFromUserDefaults(topicID: topicID) {
            // If data exists, use it to initialize the properties
            self.lessonRead = loadedProgress.lessonRead
            self.flashcardStudied = loadedProgress.flashcardStudied
            self.quizPassed = loadedProgress.quizPassed
            self.quizHighScore = loadedProgress.quizHighScore
        } else {
            // Otherwise, initialize with default values
            self.lessonRead = false
            self.flashcardStudied = false
            self.quizPassed = false
            self.quizHighScore = nil
        }
    }
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "\(Key.progress)_\(topicID)")
        }
    }
    
    static func loadFromUserDefaults(topicID: Int) -> Progress? {
        guard let savedProgress = UserDefaults.standard.object(forKey: "\(Key.progress)_\(topicID)") as? Data else { return nil }
        let decoder = JSONDecoder()
        guard let loadedProgress = try?  decoder.decode(Progress.self, from: savedProgress) else { return nil }
        return loadedProgress
    }
    
    private struct Key {
        static let progress = "Progress"
    }
    
}

extension Progress:Identifiable {
    var id: Int {
        topicID
    }
}
