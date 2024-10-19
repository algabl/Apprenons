//
//  LessonView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/18/24.
//

import SwiftUI

struct LessonView: View {
    let topic: Topic
    var viewModel: ApprenonsViewModel
    @State private var isLessonRead = false
    @State private var isQuizPassed = false
    var body: some View {
        VStack {
            Toggle("Mark as Read", isOn: $isLessonRead)
                           .onChange(of: isLessonRead) {
                               viewModel.updateProgress(for: topic, keyPath: \.lessonRead, value: isLessonRead)
                           }
            Text(topic.lessonText)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            NavigationLink {
                QuizView(quiz: topic.quiz, viewModel: viewModel)
            } label: {
                Text("\(topic.title) Quiz")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            NavigationLink {
                FlashcardsView(topic: topic, viewModel: viewModel)
            } label: {
                Text("\(topic.title) Flashcards")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let progress = viewModel.progress.first(where: { $0.topicID == topic.id }) {
                         isLessonRead = progress.lessonRead
                         isQuizPassed = progress.quizPassed
                     }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        LessonView(topic: FrenchLessonPlan.staticTopics[0], viewModel: ApprenonsViewModel())
    }
}
