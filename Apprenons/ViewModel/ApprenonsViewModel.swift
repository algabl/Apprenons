//
//  ApprenonsViewModel.swift
//  Apprenons
//
//  Created by Alexander Black on 10/11/24.
//

import Foundation

@Observable class ApprenonsViewModel {
    // MARK: - Constants
    
    // MARK: - Properties
    
    private var model: LessonPlan = FrenchLessonPlan()
    
    
    // MARK: - Initialization

    
    // MARK: - Model access
    
    var languageName: String {
        model.languageName
    }
    
    var topics: [Topic] {
        model.topics
    }
    
    var progress: [Progress] {
        model.progress
    }
    
    
    
    // MARK: - User intents
    
    // Generic function to update a specific property on a Progress object
    func updateProgress<T>(for topic: Topic, keyPath: WritableKeyPath<Progress, T>, value: T) {
        model.updateProgress(for: topic, keyPath: keyPath, value: value)
    }
    
    func toggle(property: String, for topic: Topic) {
//        model.toggle(property: property, for: topic)
    }
    
    func flip(_ flashcard: Flashcard, in topic: Topic) {
        model.flip(flashcard, in: topic )
    }
    
    
    // MARK: - Private helpers
}
