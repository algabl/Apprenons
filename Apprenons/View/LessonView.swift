//
//  LessonView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/18/24.
//

import SwiftUI

struct LessonView: View {
    let topicID: UUID
    @EnvironmentObject var viewModel: ApprenonsViewModel
    @State private var isLessonRead = false
    @State private var isQuizPassed = false
    
    var topic: Topic? {
        viewModel.topic(withID: topicID)
    }
    
    var body: some View {
        VStack {
            if let topic {
                Toggle("Mark as Read", isOn: $isLessonRead)
                               .onChange(of: isLessonRead) {
                                   viewModel.updateProgress(for: topicID, keyPath: \.lessonRead, value: isLessonRead)
                               }
                Text(topic.lessonText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                NavigationLink {
                    QuizView(topicID: topicID)
                } label: {
                    Text("\(topic.title) Quiz")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                NavigationLink {
                    FlashcardsView(topicID: topicID)
                } label: {
                    Text("\(topic.title) Flashcards")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle(topic?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let progress = viewModel.progress.first(where: { $0.topicID == topicID }) {
                         isLessonRead = progress.lessonRead
                         isQuizPassed = progress.quizPassed
                 }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        LessonView(topicID: FrenchLessonPlan.staticTopics[0].id)
    }
}
