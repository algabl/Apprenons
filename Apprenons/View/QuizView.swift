//
//  QuizView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/18/24.
//

import SwiftUI

struct QuizView: View {
    let topicID: Int
    @EnvironmentObject var viewModel: ApprenonsViewModel
    
    var topic: Topic? {
        viewModel.topic(withID: topicID)
    }
    
    var quiz: [QuizItem] {
        topic?.quiz ?? []
    }
    @State private var currentQuizItemIndex: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentQuizItemIndex) {
                ForEach(quiz.indices, id: \.self) { index in
                    QuizItemView(quizItemID: quiz[index].id, topicID: topicID, index: index, currentQuizItemIndex: $currentQuizItemIndex)
                    .tag(index)
                    .disabled(currentQuizItemIndex != index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentQuizItemIndex)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .onDisappear {
            viewModel.resetQuiz(in: topicID)
        }
    }

}

struct QuizItemView: View {
    let quizItemID: UUID
    let topicID: Int
    let index: Int
    @EnvironmentObject var viewModel: ApprenonsViewModel
    @State private var response: String = ""
    @State private var animatedBonusPercentRemaining = 0.0
    @State private var animatedBonusTimeRemaining = 0.0
    @State private var timer: Timer?

    @Binding var currentQuizItemIndex: Int {
        willSet {
            if newValue == index {
                viewModel.handleQuizItemOpen(quizItemID, in: topicID)
            }
        }
        didSet {
            if oldValue == index {
                viewModel.handleQuizItemClose(quizItemID, in: topicID)
            }
        }
    }
    
    var topic: Topic? {
        viewModel.topic(withID: topicID)
    }
    
    var quizItem: QuizItem? {
        topic?.quiz.first(where: { $0.id == quizItemID })
    }
    
    func progress(for topicID: Int) -> Progress? {
        viewModel.progress.first(where: { $0.topicID == topicID })
    }
    
    var body: some View {
        VStack {
            if let topic, let quizItem {
                Text("Score: \(topic.quizScore)")
                if quizItem.isConsumingBonusTime {
                    CountdownView(bonusTimeRemaining: animatedBonusTimeRemaining, countdownPercentage: animatedBonusPercentRemaining)
                    .onAppear {
                        // Set initial values
                        animatedBonusTimeRemaining = quizItem.bonusTimeRemaining
                        animatedBonusPercentRemaining = quizItem.bonusRemainingPercent
                        
                        // Create a timer that fires every second - with the help of AI
                        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                            withAnimation {
                                if animatedBonusTimeRemaining > 0 {
                                    animatedBonusTimeRemaining -= 1.0
                                    animatedBonusPercentRemaining = quizItem.bonusRemainingPercent
                                }
                            }
                        }
                    }
                    .onDisappear {
                        // Clean up timer when view disappears
                        timer?.invalidate()
                        timer = nil
                    }
                } else {
                    CountdownView(bonusTimeRemaining: 0.0, countdownPercentage: 0.0)
                }
                Form {
                    Text(quizItem.question)
                        .font(.headline)
                        .padding()
                    if quizItem.answers.count > 0 {
                        ForEach (quizItem.answers, id: \.self) { answer in
                            Group {
                                if let isCorrect = quizItem.isCorrect {
                                    if answer.lowercased() == quizItem.correctAnswer {
                                        HStack {
                                            Image(systemName: "checkmark")
                                            Text(answer)
                                        }
                                        .background(Color.green.opacity(0.2))
                                        .padding()
                                        .cornerRadius(8)
                                    } else if !isCorrect && answer == quizItem.answer {
                                        HStack {
                                            Image(systemName:"xmark")
                                            Text(answer)
                                        }
                                        .background(Color.red.opacity(0.2))
                                        .padding()
                                        .cornerRadius(8)
                                    } else {
                                        HStack {
                                            Text(answer)
                                                .onTapGesture {
                                                    viewModel.handleQuizAnswer(answer, for: quizItemID, in: topicID)
                                                }
                                                .padding()
                                                .cornerRadius(8)
                                        }
                                    }
                                } else {
                                    HStack {
                                        Text(answer)
                                            .onTapGesture {
                                                viewModel.handleQuizAnswer(answer, for: quizItemID, in: topicID)
                                            }
                                            .padding()
                                            .cornerRadius(8)
                                    }
                                }
                            }

                        }
                    } else {
                        if let isCorrect = quizItem.isCorrect {
                            if isCorrect {
                                TextField("Enter your response here", text: $response)
                                    .onSubmit {
                                        viewModel.handleQuizAnswer(response, for: quizItemID, in: topicID)
                                    }
                                    .background(Color.green.opacity(0.2))

                            } else {
                                TextField("Enter your response here", text: $response)
                                    .onSubmit {
                                        viewModel.handleQuizAnswer(response, for: quizItemID, in: topicID)
                                    }
                                .background(Color.red.opacity(0.2))
                                Text("Correct answer: \(quizItem.correctAnswer)")
                            }
                        } else {
                            TextField("Enter your response here", text: $response)
                                .onSubmit {
                                    viewModel.handleQuizAnswer(response, for: quizItemID, in: topicID)
                                }
                        }
                    }
                }
                if let isCorrect = quizItem.isCorrect {
                    if isCorrect {
                        Text("Correct!")
                    } else {
                        Text("Wrong!")
                    }
                    if currentQuizItemIndex == topic.quiz.count - 1 {
                        Text("Final score: \(topic.quizScore)")
                        Text("Previous high score: \(progress(for: topicID)?.quizHighScore ?? 0)")
                        Button("Finish Quiz") {
                            viewModel.backOneLevel()
                            viewModel.handleQuizFinish(for: topicID)
                        }
                    } else {
                        Button("Next Question") {
                            currentQuizItemIndex += 1
                        }
                    }
                }

            }
        }
        .onAppear() {
            if currentQuizItemIndex == index {
                viewModel.handleQuizItemOpen(quizItemID, in: topicID)
            }
        }
        .onDisappear() {
            viewModel.handleQuizItemClose(quizItemID, in: topicID)
        }
    }
}

struct CountdownView: View, Animatable {
    
    var bonusTimeRemaining: Double
    var countdownPercentage: Double
    
    var animatableData: Double {
        get { countdownPercentage }
        set { countdownPercentage = newValue }
    }
    
    private var formattedTimeRemaining: String {
        let seconds = Int(ceil(bonusTimeRemaining))
        return "\(seconds) seconds"
    }
    
    var body: some View {
        VStack {
            Text(formattedTimeRemaining)
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.blue.opacity(0.3))
                    .frame(height: 6)
                Rectangle()
                    .fill(.blue)
                    .frame(width: max(0, CGFloat(countdownPercentage) * UIScreen.main.bounds.width), height: 6)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 3))
        }
    }
}

#Preview {
    QuizView(topicID: FrenchLessonPlan.staticTopics[0].id)
}
