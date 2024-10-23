//
//  QuizView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/18/24.
//

import SwiftUI

struct QuizView: View {
    let topicID: UUID
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
                    QuizItemView(quizItemID: quiz[index].id, topicID: topicID, currentQuizItemIndex: $currentQuizItemIndex)
                    .tag(index)
                    .disabled(currentQuizItemIndex != index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentQuizItemIndex)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

struct QuizItemView: View {
    let quizItemID: UUID
    let topicID: UUID
    @EnvironmentObject var viewModel: ApprenonsViewModel
    @State private var response: String = ""
    @State private var feedback: String?
    @Binding var currentQuizItemIndex: Int
    
    var topic: Topic? {
        viewModel.topic(withID: topicID)
    }
    
    var quizItem: QuizItem? {
        topic?.quiz.first(where: { $0.id == quizItemID })
    }
    var body: some View {
        VStack {
            if let topic, let quizItem {
                Text("Score: \(topic.quizScore)")
                Form {
                    Text(quizItem.question)
                        .font(.headline)
                        .padding()
                    if let answers = quizItem.answers {
                        ForEach (answers, id: \.self) { answer in
                            Text(answer)
                                .onTapGesture {
                                    feedback = viewModel.handleQuizAnswer(answer, for: quizItem, in: topic)
                                }
                        }
                    } else {
                        TextField("Enter your response here", text: $response)
                            .onSubmit {
                                feedback = viewModel.handleQuizAnswer(response, for: quizItem, in: topic)
                            }
                    }
                }
                if let feedback {
                    Text(feedback)
                    Button("Next Question") {
                        currentQuizItemIndex += 1
                    }
                    .padding()
                }
            }


        }

    }
}

#Preview {
    QuizView(topicID: FrenchLessonPlan.staticTopics[0].id)
}
