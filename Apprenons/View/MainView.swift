//
//  MainView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/10/24.
//

import SwiftUI

struct MainView: View {
    
    let viewModel: ApprenonsViewModel
    
    var body: some View {
        TabView {
            Tab("Topics", systemImage: "lightbulb") {
                NavigationStack {
                    List(viewModel.topics) { topic in
                        TopicCell(topic: topic, viewModel: viewModel)
                    }
                    .navigationTitle("Apprenons")
                }
            }
        }
    
    }
}

struct TopicCell: View {
    let topic: Topic
    var viewModel: ApprenonsViewModel
    
    var body: some View {
        HStack {
            NavigationLink {
                LessonView(topic: topic, viewModel: viewModel)
            } label: {
                Text(topic.title)
            }
        }
    }
}

struct LessonView: View {
    let topic: Topic
    var viewModel: ApprenonsViewModel
    @State private var isLessonRead = false
    @State private var isFlashcardStudied = false
    @State private var isQuizPassed = false
    
    var body: some View {
        VStack {
            Text("Lesson about \(topic.title)")
            Toggle("Mark as Read", isOn: $isLessonRead)
                           .onChange(of: isLessonRead) {
                               viewModel.updateProgress(for: topic, keyPath: \.lessonRead, value: isLessonRead)
                           }
            NavigationLink {
                QuizView(quiz: topic.quiz)
            } label: {
                Text("\(topic.title) Quiz")
            }
            NavigationLink {
                FlashcardsView(topic: topic, viewModel: viewModel)
            } label: {
                Text("\(topic.title) Flashcards")
            }
        }
        .onAppear {
            if let progress = viewModel.progress.first(where: { $0.topicID == topic.id }) {
                         isLessonRead = progress.lessonRead
                         isFlashcardStudied = progress.flashcardStudied
                         isQuizPassed = progress.quizPassed
                     }
        }
        .navigationTitle(topic.title)
        .padding()
    }
}

struct QuizView: View {
    var quiz: [QuizItem]
    var body: some View {
        VStack {
            ForEach(quiz) { quizItem in
                Form {
                    Text(quizItem.question)
                        .font(.headline)
                        .padding()
                    if let answers = quizItem.answers {
                        ForEach (answers, id: \.self) { answer in
                            Text(answer)
                        }
                    }
                }
            }
        }
    }
}

struct FlashcardsView: View {
    let topic: Topic
    let viewModel: ApprenonsViewModel
    
    var body: some View {
        VStack {
            Text("Hello flashcards")
            ForEach(Array(topic.flashcardList)) { flashcard in
                FlashcardView(flashcard: flashcard, topic: topic, viewModel: viewModel)
            }
        }
    }
}

#Preview {
    MainView(viewModel: ApprenonsViewModel())
}
