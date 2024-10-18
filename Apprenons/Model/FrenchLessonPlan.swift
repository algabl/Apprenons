//
//  ApprenonsModel.swift
//  Apprenons
//
//  Created by Alexander Black on 10/10/24.
//

import Foundation

protocol LessonPlan {
    var languageName: String { get }
    var topics: [Topic] { get set }
    var progress: [Progress] { get set }
    mutating func updateProgress<T>(for topic: Topic, keyPath: WritableKeyPath<Progress, T>, value: T)
    mutating func flip(_ flashcard: Flashcard, in topic: Topic)
}

struct Topic: Identifiable {
    let id: Int
    let title: String
    let lessonText: String
    var flashcardList: [Flashcard]
    let quiz: [QuizItem]
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
        let correctAnswer: Int
        let questionType: QuestionType
}

struct FrenchLessonPlan: LessonPlan {
    
    // MARK: - Nested types
    
    // MARK: - Constants
    
    // MARK: - Properties
    var languageName: String = "French"
    var topics: [Topic] = [Topic(
        id: 1,
        title: "Basic Greetings and Farewells",
        lessonText: "Some helpful content",
        flashcardList: [Flashcard(front: "Hello", back: "Bonjour"), Flashcard(front: "Goodby", back: "Au revoir"), Flashcard(front: "Hi", back: "Salut"), Flashcard(front: "How are you?", back: "Comment allez-vous?")],
        quiz: [QuizItem(
            question: "What is the French word for 'Hello'?",
            answers: ["Bonjour", "Salut", "Oui", "Non"],
            correctAnswer: 0,
            questionType: .multipleChoice
        )]
    )]
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
    
    mutating func flip(_ flashcard: Flashcard, in topic: Topic) {
        guard let topicIndex = topics.firstIndex(where: { $0.id == topic.id }) else { return }
        guard let flashcardIndex = topics[topicIndex].flashcardList.firstIndex(where: { $0.id == flashcard.id }) else { return }

        topics[topicIndex].flashcardList[flashcardIndex].isFaceUp.toggle()
    }
    
    // Generic function to update a specific property on a Progress object
    mutating func updateProgress<T>(for topic: Topic, keyPath: WritableKeyPath<Progress, T>, value: T) {
        if let index = progress.firstIndex(where: { $0.topicID == topic.id }) {
            progress[index][keyPath: keyPath] = value
        }
    }
        
    // MARK: - Private helpers
}










