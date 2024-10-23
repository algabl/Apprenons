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
    
    var body: some View {
        NavigationStack {
            List(viewModel.topics) { topic in
                TopicCell(topicID: topic.id)
            }
            .navigationTitle("Apprenons")
        }
    }
}

struct TopicCell: View {
    let topicID: UUID
    @EnvironmentObject var viewModel: ApprenonsViewModel

    var body: some View {
        HStack {
            NavigationLink {
                LessonView(topicID: topicID)
            } label: {
                if let title = viewModel.topic(withID: topicID)?.title {
                    Text(title)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
