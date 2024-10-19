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

#Preview {
    MainView(viewModel: ApprenonsViewModel())
}
