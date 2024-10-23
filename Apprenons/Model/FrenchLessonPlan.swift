//
//  ApprenonsModel.swift
//  Apprenons
//
//  Created by Alexander Black on 10/10/24.
//

import Foundation

protocol LessonPlan {
    var languageName: String { get }
    static var staticTopics: [Topic] { get }
    var topics: [Topic] { get set }
    var progress: [Progress] { get set }
    mutating func updateProgress<T>(for topicID: UUID, keyPath: WritableKeyPath<Progress, T>, value: T)
    mutating func flip(_ flashcardID: UUID, in topicID: UUID)
    mutating func resetFlashcards(for topicIndex: Int)
    mutating func setQuizScore(_ score: Int, for topic: Topic)
}

struct Topic: Identifiable {
    let id: UUID = UUID()
    let title: String
    let lessonText: String
    var flashcardList: [Flashcard]
    var quiz: [QuizItem]
    var quizScore: Int?
}

struct Flashcard: Identifiable {
    let id: UUID = UUID()
    let front: String
    let back: String
    var isFaceUp: Bool = true
}

enum QuestionType {
    case multipleChoice
    case fllInTheBlank
}

struct QuizItem: Identifiable {
        let id: UUID = UUID()
        let question: String
        let answers: [String]?
        let correctAnswer: String
        let questionType: QuestionType
        var answered: Bool = false
}

struct FrenchLessonPlan: LessonPlan {
    
    // MARK: - Nested types
    
    // MARK: - Constants
    
    // MARK: - Properties
    var languageName: String = "French"
    
    static var staticTopics: [Topic] = [Topic(
        title: "Basic Greetings and Farewells",
        lessonText: "Some helpful content",
        flashcardList: [Flashcard(front: "Hello", back: "Bonjour"), Flashcard(front: "Goodbye", back: "Au revoir"), Flashcard(front: "Hi", back: "Salut"), Flashcard(front: "How are you?", back: "Comment allez-vous?")],
        quiz: [
            QuizItem(
                question: "What is the French word for 'Hello'?",
                answers: ["Bonjour", "Salut", "Oui", "Non"],
                correctAnswer: "bonjour",
                questionType: .multipleChoice
            ),
            QuizItem(
                question: "What does 'Oui' mean?",
                answers: nil,
                correctAnswer: "yes",
                questionType: .multipleChoice
            ),
        ]
    )]
    
    var topics: [Topic] = FrenchLessonPlan.staticTopics
    var progress: [Progress]
    
    init() {
        self.progress = topics.map { topic in
            if let loadedProgress = Progress.loadFromUserDefaults(topicID: topic.id){
                return loadedProgress
            } else {
                return Progress(topicID: topic.id)
            }
        }
    }
    
    // MARK: - Helpers
    
    mutating func flip(_ flashcardID: UUID, in topicID: UUID) {
        guard let topicIndex = topics.firstIndex(where: { $0.id == topicID }) else { return }
        guard let flashcardIndex = topics[topicIndex].flashcardList.firstIndex(where: { $0.id == flashcardID }) else { return }

        topics[topicIndex].flashcardList[flashcardIndex].isFaceUp.toggle()
    }
    
    mutating func resetFlashcards(for topicIndex: Int) {
        
        var selectedTopic = topics[topicIndex]
        
        for index in selectedTopic.flashcardList.indices {
            selectedTopic.flashcardList[index].isFaceUp = true
        }

        topics[topicIndex] = selectedTopic
    }
    
    // Generic function to update a specific property on a Progress object
    mutating func updateProgress<T>(for topicID: UUID, keyPath: WritableKeyPath<Progress, T>, value: T) {
        if let index = progress.firstIndex(where: { $0.topicID == topicID }) {
            progress[index][keyPath: keyPath] = value
        }
    }
    
    mutating func setQuizScore(_ score: Int, for topic: Topic) {
        if let index = topics.firstIndex(where: { $0.id == topic.id }) {
            topics[index].quizScore = score
        }
    }
    
    mutating func setAnswered(_ answered: Bool, for quizItem: QuizItem, in topic: Topic) {
        guard let index = topics.firstIndex(where: { $0.id == topic.id }) else { return }
        guard let quizItemIndex = topics[index].quiz.firstIndex(where:  { $0.id == topic.quiz[index].id }) else { return }
        
        topics[index].quiz[quizItemIndex].answered = answered
    }
            
    // MARK: - Private helpers
}










