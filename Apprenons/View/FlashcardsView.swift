//
//  FlashcardsView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/17/24.
//

import SwiftUI


struct Constants {
    static var cornerRadius: CGFloat = 10
}

struct FlashcardsView: View {
    let topic: Topic
    let viewModel: ApprenonsViewModel
    
    @State private var isFlashcardStudied = false
    @State private var shuffledFlashcards: [Flashcard] = []

    
    var body: some View {
        VStack {
            TabView {
                ForEach(Array(shuffledFlashcards)) { flashcard in
                    FlashcardView(flashcard: flashcard, topic: topic, viewModel: viewModel)
                }
              
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
          
            Toggle("Mark as Studied", isOn: $isFlashcardStudied)
                .onChange(of: isFlashcardStudied) {
                    viewModel.updateProgress(for: topic, keyPath: \.flashcardStudied, value: isFlashcardStudied)
            }
        }
        .padding()
        .onAppear {
            if let progress = viewModel.progress.first(where: { $0.topicID == topic.id }) {
                isFlashcardStudied = progress.flashcardStudied
            }
            shuffledFlashcards = topic.flashcardList.shuffled()
        }
        .onDisappear {
            viewModel.resetFlashcards(in: topic)
        }
    }
}

struct FlashcardView: View {
    let flashcard: Flashcard
    var topic: Topic
    let viewModel: ApprenonsViewModel
    
    var body: some View {
        ZStack {
            Group {
                if viewModel.isFaceUp(flashcard, in: topic) {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(.white)
                    RoundedRectangle(cornerRadius: Constants.cornerRadius).stroke()
                    Text(flashcard.front)
                        .font(.largeTitle)
                } else {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(.white)
                    RoundedRectangle(cornerRadius: Constants.cornerRadius).stroke()
                    Text(flashcard.back)
                        .font(.largeTitle)
                }
            }
           
        }
        .onTapGesture {
            viewModel.flip(flashcard, in: topic)
        }
        .navigationTitle("Flashcards")
        .navigationBarTitleDisplayMode(.inline)
        .foregroundStyle(.blue)
     
    }
}

#Preview {
    NavigationStack {
        FlashcardsView(topic: FrenchLessonPlan.staticTopics[0], viewModel: ApprenonsViewModel())
    }
}
