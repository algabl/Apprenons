//
//  ApprenonsViewModel.swift
//  Apprenons
//
//  Created by Alexander Black on 10/11/24.
//

import Foundation

// help handle navigation, with help from Claude.ai
enum NavigationState: Hashable {
    case lesson(Int)
    case quiz(Int)
    case flashcards(Int)
}

@Observable class ApprenonsViewModel: ObservableObject {
    // MARK: - Constants
    

    
    // MARK: - Properties
    
    private var model: LessonPlan = FrenchLessonPlan()
    var navigationPath: [NavigationState] = []
    var audioManager: AudioManager = AudioManager.shared

    
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
    
    func progressForTopic(withID id : Int) -> Progress {
        return model.progress.first(where: { $0.id == id }) ?? Progress(topicID: id)
    }
    
    func quizItem(withID id: UUID, in topicID: Int) -> QuizItem? {
        return topic(withID: topicID)?.quiz.first(where: { $0.id == id })
    }
    
    func flashcard(withID id: UUID, in topicID: Int) -> Flashcard? {
        return topic(withID: topicID)?.flashcardList.first(where: { $0.id == id })
    }
    
    func isFaceUp(_ flashcardID: UUID, in topicID: Int) -> Bool {
        guard let flashcard = flashcard(withID: flashcardID, in: topicID) else { return true }
        
        return flashcard.isFaceUp
    }
    

    
    
    // MARK: - User intents
    
    // Generic function to update a specific property on a Progress object
    func updateProgress<T>(for topicID: Int, keyPath: WritableKeyPath<Progress, T>, value: T) {
        model.updateProgress(for: topicID, keyPath: keyPath, value: value)
    }
    
    func toggle(property: String, for topic: Topic) {
//        model.toggle(property: property, for: topic)
    }
    
    func flip(_ flashcardID: UUID, in topicID: Int) {
        model.flip(flashcardID, in: topicID )
    }
    
    func handleQuizAnswer(_ answer: String, for quizItemID: UUID, in topicID: Int) {
        let quizIndex: Int? = topic(withID: topicID)?.quiz.firstIndex(where: { $0.id == quizItemID })
        
        if let quizIndex {
            model.updateValue(for: topicID, keyPath: \.quiz[quizIndex].answer, value: answer)
            if let isCorrect = quizItem(withID: quizItemID, in: topicID)?.isCorrect, isCorrect {
                playSound("Ding")
            }
        }
    }
    
    func handleQuizItemOpen(_ quizItemID: UUID, in topicID: Int) {
        let quizIndex: Int? = topic(withID: topicID)?.quiz.firstIndex(where: { $0.id == quizItemID })
        
        if let quizIndex {
            model.updateValue(for: topicID, keyPath: \.quiz[quizIndex].isQuestionOpen, value: true)
        }
    }
    
    func handleQuizItemClose(_ quizItemID: UUID, in topicID: Int) {
        let quizIndex: Int? = topic(withID: topicID)?.quiz.firstIndex(where: { $0.id == quizItemID })
        
        if let quizIndex {
            model.updateValue(for: topicID, keyPath: \.quiz[quizIndex].isQuestionOpen, value: false)
        }
    }
    
    func handleQuizFinish(for topicID: Int) {
        var quizPassed: Bool = true
        let topic: Topic? = topic(withID: topicID)
        
        guard let topic else { return }
        
        
        // check if all questions are correct
        for quizItem in topic.quiz {
            if let isCorrect = quizItem.isCorrect, !isCorrect {
                quizPassed = false
                // exit for loop
                break
            }
        }
        
        
        if quizPassed {
            model.updateProgress(for: topicID, keyPath: \.quizPassed, value: quizPassed)
            if let highScore = progressForTopic(withID: topicID).quizHighScore, highScore < topic.quizScore {
                model.updateProgress(for: topicID, keyPath: \.quizHighScore, value: topic.quizScore)
            } else {
                model.updateProgress(for: topicID, keyPath: \.quizHighScore, value: topic.quizScore)
            }
        }
    }
    
    func backOneLevel() {
        navigationPath.removeLast()
    }
    
    func resetFlashcards(in topicID: Int) {
        guard let topicIndex = topics.firstIndex(where: { $0.id == topicID }) else { return }
        model.resetFlashcards(for: topicIndex)
    }
    
    func resetQuiz(in topicID: Int) {
        guard let topicIndex = topics.firstIndex(where: { $0.id == topicID }) else { return }
        model.resetQuiz(for: topicIndex)
    }
    
    // MARK: - Private helpers
    private func playSound(_ sound: String?) {
        if let sound {
            audioManager.playSound(named: sound)
        }
    }
}
