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
    mutating func updateProgress<T>(for topicID: Int, keyPath: WritableKeyPath<Progress, T>, value: T)
    mutating func updateValue<T>(for topicID: Int, keyPath: WritableKeyPath<Topic, T>, value: T)
    mutating func flip(_ flashcardID: UUID, in topicID: Int)
    mutating func resetFlashcards(for topicIndex: Int)
    mutating func resetQuiz(for topicIndex: Int)
}

struct Topic: Identifiable {
    let id: Int
    let title: String
    let lessonText: String
    var flashcardList: [Flashcard]
    var quiz: [QuizItem]
    var quizScore: Int {
        var totalScore: Int = 0
        for quizItem in quiz {
            totalScore += quizItem.score
        }
        return totalScore
    }
}

struct Flashcard: Identifiable {
    let id: UUID = UUID()
    let front: String
    let back: String
    var isFaceUp: Bool = true
    

}

struct QuizItem: Identifiable {
    let id: UUID = UUID()
    let question: String
    let answers: [String]
    let correctAnswer: String
    
    // MARK: - Properties
    var answer: String? {
        willSet {
            if let newValue {
                if newValue.lowercased() == correctAnswer {
                    isCorrect = true
                } else {
                    isCorrect = false
                }
                stopUsingBonusTime()
            }
        }
    }
    
    var isCorrect: Bool? {
        willSet {
            if newValue != nil {
                stopUsingBonusTime()
            }
        }
    }
    
    var bonusTimeLimit: TimeInterval = Constants.bonusTime
    var isQuestionOpen: Bool = false {
        didSet {
            if isQuestionOpen {
                startUsingBonusTime()
            } else {
                stopUsingBonusTime()
            }
        }
    }
    
    var questionOpened: Date?
    var questionFinished: Date?
    
    // MARK: - Computed properties
    
    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - timeTaken)
    }
    
    var bonusRemainingPercent: Double {
        (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
    }
    
    var isConsumingBonusTime: Bool {
        isQuestionOpen && bonusTimeRemaining > 0 && questionFinished == nil && !(isCorrect ?? false)
    }
    
    var score: Int {
        if let isCorrect, isCorrect {
            return Constants.basePoints + bonusScore
        }
        return 0
    }
    
    // MARK: - Private helpers
    
    private var bonusScore: Int {
        Int(ceil(Double(Constants.bonusTime - timeTaken) / Double(Constants.bonusDivider)))
    }
    
    private var timeTaken: TimeInterval {
        guard let questionOpened else { return 0 }
        if let questionFinished {
            return questionFinished.timeIntervalSince(questionOpened)
        }
        return Date().timeIntervalSince(questionOpened)
    }
    
    private mutating func startUsingBonusTime() {
        if isConsumingBonusTime && questionOpened == nil {
            questionOpened = Date()
        }
    }
    
    private mutating func stopUsingBonusTime() {
        if questionOpened != nil, questionFinished == nil {
            questionFinished = Date()
        }
    }
    
    // MARK: - Constants
    struct Constants {
        static let basePoints = 10
        static let maxBonus = 10
        static let bonusTime = 20.0
        static let bonusDivider = 2
    }
}

struct FrenchLessonPlan: LessonPlan {
    
    // MARK: - Nested types
    
    // MARK: - Constants
    
    // MARK: - Properties
    
    var languageName: String = "French"
    
    // AI was used in generating lesson content, especially the lessonText
    static var staticTopics: [Topic] = [
        Topic(
            id: 0,
            title: "Basic Greetings and Farewells",
            lessonText: "In this lesson, we'll cover some basic French greetings to get you started. To say 'Hello,' use Bonjour, which is common during the day, and for a more specific greeting in the afternoon, say Bon après-midi ('Good afternoon'). When it's time for bed, say Bonne nuit ('Good night'). If you're parting ways, Au revoir means 'Goodbye,' while a more casual 'Hi' can be expressed with Salut. When asking someone how they are, you can say Comment allez-vous? ('How are you?') and respond with Ça va bien ('I'm good'). Lastly, to say 'See you later,' use À bientôt. Practice these phrases to start mastering French greetings!",
            flashcardList: [
                Flashcard(front: "Hello", back: "Bonjour"),
                Flashcard(front: "Good afternoon", back: "Bon après-midi"),
                Flashcard(front: "Good night", back: "Bonne nuit"),
                Flashcard(front: "Goodbye", back: "Au revoir"),
                Flashcard(front: "Hi", back: "Salut"),
                Flashcard(front: "How are you?", back: "Comment allez-vous?"),
                Flashcard(front:"I'm good", back: "Ça va bien"),
                Flashcard(front: "See you later", back: "À bientôt")],
            quiz: [
                QuizItem(
                    question: "What is the French word for 'Hello'?",
                    answers: ["Bonjour", "Salut", "Oui", "Non"],
                    correctAnswer: "bonjour"
                ),
                QuizItem(
                    question: "What does 'Oui' mean?",
                    answers: [],
                    correctAnswer: "yes"
                ),
                QuizItem(
                    question: "'Bonjour' means 'Good night' in French",
                    answers: ["True", "False"],
                    correctAnswer: "false"
                )
            ]
        ),
        Topic(
            id: 1,
            title: "Common Phrases",
            lessonText: "In this lesson, we’ll focus on polite expressions in French. To say 'Please,' use S'il vous plaît, and to express gratitude, say 'Thank you' with Merci. When someone thanks you, reply with De rien, meaning 'You’re welcome.' If you need to apologize, say 'I’m sorry' with Désolé(e). To ask for directions or the location of something, use Où est...?, which means 'Where is...?' Lastly, if you'd like to make a polite request, say 'I would like...' with Je voudrais.... These phrases will help you communicate more politely and effectively in French!",
            flashcardList: [
                Flashcard(front: "Please", back: "S'il vous plaît"),
                Flashcard(front: "Thank you", back: "Merci"),
                Flashcard(front: "You're welcome", back: "De rien"),
                Flashcard(front: "I'm sorry", back: "Désolé(e)"),
                Flashcard(front: "Where is...?", back: "Où est...?"),
                Flashcard(front: "I would like...", back: "Je voudrais..."),
            ],
            quiz: [
                QuizItem(
                    question: "What is the French word/phrase for 'Please'?",
                    answers: ["Merci", "S'il vous plaît", "De rien", "Désolé(e)"],
                    correctAnswer: "s'il vous plaît"
                ),
                QuizItem(
                    question: "How do you say 'Thank you' in French?",
                    answers: [],
                    correctAnswer: "merci"
                ),
                QuizItem(
                    question: "'De rien' means 'You're welcome' in French.",
                    answers: ["True", "False"],
                    correctAnswer: "true"
                ),
                QuizItem(
                    question: "What is the French phrase for 'I would like'?",
                    answers: ["Je voudrais", "S'il vous plaît", "Où est...?", "Merci"],
                    correctAnswer: "je voudrais"
                ),
                QuizItem(
                    question: "How do you ask 'Where is...?' in French?",
                    answers: ["De rien", "Où est...?", "Désolé(e)", "Je voudrais"],
                    correctAnswer: "où est...?"
                )
            ]
        ),
        Topic(
            id: 2,
            title: "Numbers (1-10)",
            lessonText: "In this lesson, we’ll practice counting from one to ten in French. Start with 'One' by saying Un, followed by 'Two,' which is Deux. For 'Three,' say Trois, and for 'Four,' use Quatre. 'Five' is Cinq, while 'Six' is the same in both French and English, Six. To say 'Seven,' use Sept, and 'Eight' is Huit. For 'Nine,' say Neuf, and finally, 'Ten' is Dix. Practice these numbers out loud to get familiar with French counting from 1 to 10!",
            flashcardList: [
                Flashcard(front: "One (1)", back: "Un"),
                Flashcard(front: "Two (2)", back: "Deux"),
                Flashcard(front: "Three (3)", back: "Trois"),
                Flashcard(front: "Four (4)", back: "Quatre"),
                Flashcard(front: "Five (5)", back: "Cinq"),
                Flashcard(front: "Six (6)", back: "Six"),
                Flashcard(front: "Seven (7)", back: "Sept"),
                Flashcard(front: "Eight (8)", back: "Huit"),
                Flashcard(front: "Nine (9)", back: "Neuf"),
                Flashcard(front: "Ten (10)", back: "Dix")
            ],
            quiz: [
                QuizItem(
                    question: "What is the French word for 'One'?",
                    answers: ["Un", "Deux", "Trois", "Cinq"],
                    correctAnswer: "un"
                ),
                QuizItem(
                    question: "What does 'Cinq' mean?",
                    answers: [],
                    correctAnswer: "five"
                ),
                QuizItem(
                    question: "'Sept' means 'Eight' in French",
                    answers: ["True", "False"],
                    correctAnswer: "false"
                )
            ]
        ),
        Topic(
            id: 3,
            title: "Colors",
            lessonText: "In this lesson, we'll learn how to say different colors in French. Colors are a fun way to describe the world around you! To say 'Red,' use 'Rouge,' and for 'Blue,' say 'Bleu(e).' If you want to say 'Green,' use 'Vert(e),' and 'Yellow' is 'Jaune.' Lastly, to describe something as 'Black,' use 'Noir(e).' Note that some colors in French, like 'Bleu(e),' 'Vert(e),' and 'Noir(e),' have different endings depending on whether they describe something masculine or feminine. Practice using these colors with objects around you to become more familiar with them!",
            flashcardList: [
                Flashcard(front: "Red", back: "Rouge"),
                Flashcard(front: "Blue", back: "Bleu(e)"),
                Flashcard(front: "Green", back: "Vert(e)"),
                Flashcard(front: "Yellow", back: "Jaune"),
                Flashcard(front: "Black", back: "Noir(e)")
            ],
            quiz: [
                QuizItem(
                    question: "Select the correct translation of 'The school bus is yellow'",
                    answers: ["Le bus scolaire est jaune", "Le bus scolaire est rouge", "Le bus scolaire est bleu"],
                    correctAnswer: "le bus scolaire est jaune"
                ),
                QuizItem(
                    question: "What is the French word for 'Red'?",
                    answers: ["Noir(e)", "Rouge", "Bleu(e)", "Vert(e)"],
                    correctAnswer: "rouge"
                ),
                QuizItem(
                    question: "How do you say 'Green' in French?",
                    answers: ["Jaune", "Bleu(e)", "Vert(e)", "Rouge"],
                    correctAnswer: "vert(e)"
                ),
                QuizItem(
                    question: "'Noir(e)' means 'Black' in French.",
                    answers: ["True", "False"],
                    correctAnswer: "true"
                ),
                QuizItem(
                    question: "Which color does 'Bleu(e)' refer to?",
                    answers: ["Red", "Green", "Blue", "Yellow"],
                    correctAnswer: "blue"
                )
            ]
        ),
        Topic(
            id: 4,
            title: "Family Members",
            lessonText: "In this lesson, we’ll learn the French words for family members. Family is a big part of life, and being able to talk about your relatives in another language is important. The French word for 'Mother' is 'Mère,' and for 'Father,' it's 'Père.' To say 'Brother,' use 'Frère,' and for 'Sister,' say 'Sœur.' If you’re talking about your grandparents, 'Grandfather' is 'Grand-père' and 'Grandmother' is 'Grand-mère.' To talk about your 'Uncle,' use 'Oncle,' and 'Aunt' is 'Tante.' These words will help you describe your family in French and understand others when they talk about theirs.",
            flashcardList: [
                Flashcard(front: "Mother", back: "Mère"),
                Flashcard(front: "Father", back: "Père"),
                Flashcard(front: "Brother", back: "Frère"),
                Flashcard(front: "Sister", back: "Sœur"),
                Flashcard(front: "Grandfather", back: "Grand-père"),
                Flashcard(front: "Grandmother", back: "Grand-mère"),
                Flashcard(front: "Uncle", back: "Oncle"),
                Flashcard(front: "Aunt", back: "Tante")
            ],
            quiz: [
                QuizItem(
                    question: "What is the French word for 'Father'?",
                    answers: ["Oncle", "Père", "Frère", "Grand-père"],
                    correctAnswer: "père"
                ),
                QuizItem(
                    question: "How do you say 'Sister' in French?",
                    answers: ["Sœur", "Mère", "Tante", "Grand-mère"],
                    correctAnswer: "sœur"
                ),
                QuizItem(
                    question: "'Grand-mère' means 'Grandmother' in French.",
                    answers: ["True", "False"],
                    correctAnswer: "true"
                ),
                QuizItem(
                    question: "Select the correct translation for 'Uncle'.",
                    answers: ["Père", "Oncle", "Frère", "Grand-père"],
                    correctAnswer: "oncle"
                ),
                QuizItem(
                    question: "What is the French word for 'Aunt'?",
                    answers: ["Tante", "Mère", "Sœur", "Grand-mère"],
                    correctAnswer: "tante"
                )
            ]
        ),
        Topic(
            id: 5,
            title: "Food and Drink",
            lessonText: "Fooooood and drink",
            flashcardList: [
                
            ],
            quiz: []
        ),
        Topic(
            id: 6,
            title: "Common adjectives",
            lessonText: "Beaux",
            flashcardList: [],
            quiz: [
                
            ]
        ),
        Topic(
            id: 7,
            title: "Days of the week",
            lessonText: "7 of them",
            flashcardList: [
                Flashcard(front: "Sunday", back: "Dimanche"),
                Flashcard(front: "Monday", back: "Lundi"),
                Flashcard(front: "Tuesday", back: "Mardi"),
                Flashcard(front: "Wednesday", back: "Mercredi"),
                Flashcard(front: "Thursday", back: "Vendredi"),
                Flashcard(front: "Friday", back: ""),
                Flashcard(front: "Saturday", back: "Samedi")
            ],
            quiz: [
                
            ]
        )
    ]
    
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
    
    mutating func flip(_ flashcardID: UUID, in topicID: Int) {
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
    
    mutating func resetQuiz(for topicIndex: Int) {
        var selectedTopic = topics[topicIndex]
        
        for index in selectedTopic.quiz.indices {
            selectedTopic.quiz[index].answer = nil
            selectedTopic.quiz[index].isCorrect = nil
            selectedTopic.quiz[index].isQuestionOpen = false
            selectedTopic.quiz[index].questionOpened = nil
            selectedTopic.quiz[index].questionFinished = nil
        }
        
        topics[topicIndex] = selectedTopic
    }
        
    // Generic function to update a specific property on a Progress object
    mutating func updateProgress<T>(for topicID: Int, keyPath: WritableKeyPath<Progress, T>, value: T) {
        if let index = progress.firstIndex(where: { $0.topicID == topicID }) {
            progress[index][keyPath: keyPath] = value
        }
    }
    
    mutating func updateValue<T>(for topicID: Int, keyPath: WritableKeyPath<Topic, T>, value: T) {
        if let index = topics.firstIndex(where: { $0.id == topicID }) {
            topics[index][keyPath: keyPath] = value
        }
    }
            
    // MARK: - Private helpers
    
 
    
    
}










