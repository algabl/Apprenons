//
//  LessonView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/18/24.
//

import SwiftUI

struct LessonView: View {
    let topicID: Int
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
                HStack {
                    NavigationLink(value: NavigationState.quiz(topicID)) {
                        Text("\(topic.title) Quiz")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    if viewModel.progressForTopic(withID: topicID).quizPassed {
                        Image(systemName: "trash")
                            .padding()
                            .background(Color.red)
                            .foregroundStyle(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                viewModel.updateProgress(for: topicID, keyPath: \.quizPassed, value: false)
                            }
                    }
                }
         
                NavigationLink(value: NavigationState.flashcards(topicID)) {
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
