//
//  MainView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/10/24.
//

import SwiftUI

struct Topic: Identifiable {
    var title: String
    var id: Int { title.hashValue }
}


let topics = [
    Topic(title: "Greetings")
]

struct MainView: View {
    var body: some View {
        NavigationStack {
            List(topics) { topic in
                TopicCell(topic: topic)
            }
            .listStyle(.plain)
            .navigationTitle("Apprenons")
        }
    }
}

struct TopicCell: View {
    let topic: Topic
    
    var body: some View {
        HStack {
            NavigationLink {
                LessonView(topic: topic)
            } label: {
                Text(topic.title)
            }
        }
    }
}

struct LessonView: View {
    let topic: Topic
    var body: some View {
        VStack{
            Text("Lesson about topic \(topic.title)")
            NavigationLink {
                QuizView(topic: topic)
            } label: {
                Text("\(topic.title) Quiz")
            }
        }
        .navigationTitle(topic.title)
    }
}

struct QuizView: View {
    var topic: Topic
    var body: some View {
        VStack {
            Form {
                Section {
                    Text("Hello")
                }
                Section {
                    Text("a.")
                }
            }
        }
    }
}

#Preview {
    MainView()
}
