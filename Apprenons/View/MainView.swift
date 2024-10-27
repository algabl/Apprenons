//
//  MainView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/10/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: ApprenonsViewModel
    
    var body: some View {
        TabView {
            TopicsView()
                .tabItem {
                    Label("Topics", systemImage: "lightbulb")
                }
        }
    }
}

struct TopicsView: View {
    @EnvironmentObject var viewModel: ApprenonsViewModel
    @State private var path: [NavigationState] = []

    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            List(viewModel.topics) { topic in
                TopicCell(topicID: topic.id)
            }
            .navigationTitle("Apprenons")
            .navigationDestination(for: NavigationState.self) { state in
                switch state {
                case .lesson(let topicID):
                    LessonView(topicID: topicID)
                case .quiz(let topicID):
                    QuizView(topicID: topicID)
                case .flashcards(let topicID):
                    FlashcardsView(topicID: topicID)
                }
            }
        }
    }
}

struct TopicCell: View {
    let topicID: Int
    @EnvironmentObject var viewModel: ApprenonsViewModel

    var body: some View {
        HStack {
            NavigationLink(value: NavigationState.lesson(topicID)) {
                if let title = viewModel.topic(withID: topicID)?.title {
                    Text(title)
                }
            }
            Image(systemName: viewModel.progressForTopic(withID: topicID).lessonRead ? "book.fill" : "book")
                .onTapGesture {
                    viewModel.updateProgress(for: topicID, keyPath: \.lessonRead, value: !viewModel.progressForTopic(withID: topicID).lessonRead)
                }
            Image(systemName: viewModel.progressForTopic(withID: topicID).flashcardStudied ? "list.clipboard.fill" : "list.clipboard")
                .onTapGesture {
                    viewModel.updateProgress(for: topicID, keyPath: \.flashcardStudied, value: !viewModel.progressForTopic(withID: topicID).flashcardStudied)
                }
            Image(systemName: viewModel.progressForTopic(withID: topicID).quizPassed ? "trophy.fill" : "trophy")
                .onTapGesture {
                    if viewModel.progressForTopic(withID: topicID).quizPassed {
                        viewModel.updateProgress(for: topicID, keyPath: \.quizPassed, value: !viewModel.progressForTopic(withID: topicID).quizPassed)
                    }
                }
        }
    }
}

#Preview {
    MainView()
}
