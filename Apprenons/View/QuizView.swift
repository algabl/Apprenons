//
//  QuizView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/18/24.
//

import SwiftUI

struct QuizView: View {
    let quiz: [QuizItem]
    let viewModel: ApprenonsViewModel
    
    @State private var currentQuizItemIndex: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentQuizItemIndex) {
                ForEach(quiz.indices, id: \.self) { index in
                    QuizItemView(quizItem: quiz[index], viewModel: viewModel, currentQuizItemIndex: $currentQuizItemIndex)
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
    let quizItem: QuizItem
    let viewModel: ApprenonsViewModel
    @State private var response: String = ""
    @State private var feedback: String?
    @Binding var currentQuizItemIndex: Int
    var body: some View {
        VStack {
            Form {
                Text(quizItem.question)
                    .font(.headline)
                    .padding()
                if let answers = quizItem.answers {
                    ForEach (answers, id: \.self) { answer in
                        Text(answer)
                            .onTapGesture {
                                feedback = viewModel.handleQuizAnswer(answer, in: quizItem)
                            }
                    }
                } else {
                    TextField("Enter your response here", text: $response)
                        .onSubmit {
                            feedback = viewModel.handleQuizAnswer(response, in: quizItem)
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

#Preview {
    QuizView(quiz: FrenchLessonPlan.staticTopics[0].quiz, viewModel: ApprenonsViewModel())
}
