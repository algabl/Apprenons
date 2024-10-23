//
//  ApprenonsViewModel.swift
//  Apprenons
//
//  Created by Alexander Black on 10/11/24.
//

import Foundation

@Observable class ApprenonsViewModel: ObservableObject {
    // MARK: - Constants
    
    struct Constants {
        static let basePoints = 10
        static let maxBonus = 10
        static let bonusTime = 20
        static let bonusDivider = 2
    }
    
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
    
    func topic(withID id: UUID) -> Topic? {
        return model.topics.first(where: { $0.id == id })
    }
    
    func quizItem(withID id: UUID, in topicID: UUID) -> QuizItem? {
        return topic(withID: topicID)?.quiz.first(where: { $0.id == id })
    }
    
    func flashcard(withID id: UUID, in topicID: UUID) -> Flashcard? {
        return topic(withID: topicID)?.flashcardList.first(where: { $0.id == id })
    }
    
    func isFaceUp(_ flashcardID: UUID, in topicID: UUID) -> Bool {
        guard let flashcard = flashcard(withID: flashcardID, in: topicID) else { return true }
        
        return flashcard.isFaceUp
    }
    

    
    
    // MARK: - User intents
    
    // Generic function to update a specific property on a Progress object
    func updateProgress<T>(for topicID: UUID, keyPath: WritableKeyPath<Progress, T>, value: T) {
        model.updateProgress(for: topicID, keyPath: keyPath, value: value)
    }
    
    func toggle(property: String, for topic: Topic) {
//        model.toggle(property: property, for: topic)
    }
    
    func flip(_ flashcardID: UUID, in topicID: UUID) {
        model.flip(flashcardID, in: topicID )
    }
    
    func handleQuizAnswer(_ answer: String, for quizItem: QuizItem, in topic: Topic) -> String {
        if answer.lowercased() == quizItem.correctAnswer && !quizItem.answered {
            var newScore: Int
            if let quizScore = topic.quizScore {
                newScore = quizScore + Constants.basePoints
            } else {
                newScore = Constants.basePoints
            }

            
            model.setQuizScore(newScore, for: topic)
            
            return "Correct!"
            
        }
        return "Incorrect :("
    }
    
    func resetFlashcards(in topicID: UUID) {
        guard let topicIndex = topics.firstIndex(where: { $0.id == topicID }) else { return }
        model.resetFlashcards(for: topicIndex)
    }
    
    // MARK: - Private helpers
}
