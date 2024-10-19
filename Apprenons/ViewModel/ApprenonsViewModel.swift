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
    
    func topic(withID id: Int) -> Topic? {
        return model.topics.first(where: { $0.id == id })
    }
    
    func isFaceUp(_ flashcard: Flashcard, in topic: Topic) -> Bool {
        guard let topic = model.topics.first(where: { $0.id == topic.id }) else { return true }
        guard let flashcard = topic.flashcardList.first(where: { $0.id == flashcard.id }) else { return true }
        
        return flashcard.isFaceUp
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
    
    func handleQuizAnswer(_ answer: String, in quizItem: QuizItem) -> String {
        if answer.lowercased() == quizItem.correctAnswer {
            return "Correct!"
        }
        return "Incorrect :("
    }
    
    func resetFlashcards(in topic: Topic) {
        guard let topicIndex = topics.firstIndex(where: { $0.id == topic.id }) else { return }
        model.resetFlashcards(for: topicIndex)
    }
    
    // MARK: - Private helpers
}
