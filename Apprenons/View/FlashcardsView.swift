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
    let topicID: UUID
    @EnvironmentObject var viewModel: ApprenonsViewModel

    @State private var isFlashcardStudied = false
    @State private var shuffledFlashcards: [Flashcard] = []

    var topic: Topic? {
        viewModel.topic(withID: topicID)
    }
    
    var body: some View {
        VStack {
            TabView {
                ForEach(shuffledFlashcards) { flashcard in
                    FlashcardView(flashcardID: flashcard.id, topicID: topicID)
                }
              
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
          
            Toggle("Mark as Studied", isOn: $isFlashcardStudied)
                .onChange(of: isFlashcardStudied) {
                    viewModel.updateProgress(for: topicID, keyPath: \.flashcardStudied, value: isFlashcardStudied)
            }
        }
        .padding()
        .onAppear {
            if let progress = viewModel.progress.first(where: { $0.topicID == topicID }) {
                isFlashcardStudied = progress.flashcardStudied
            }
            shuffledFlashcards = topic?.flashcardList.shuffled() ?? []
        }
        .onDisappear {
            viewModel.resetFlashcards(in: topicID)
        }
    }
}

struct FlashcardView: View {
    let flashcardID: UUID
    var topicID: UUID
    @EnvironmentObject var viewModel: ApprenonsViewModel
    
    var flashcard: Flashcard? {
        viewModel.flashcard(withID: flashcardID, in: topicID)
    }
    
    var body: some View {
        ZStack {
            Group {
                if let flashcard {
                    if flashcard.isFaceUp {
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
           
        }
        .onTapGesture {
            viewModel.flip(flashcardID, in: topicID)
        }
        .navigationTitle("Flashcards")
        .navigationBarTitleDisplayMode(.inline)
        .foregroundStyle(.blue)
     
    }
}

#Preview {
    NavigationStack {
        FlashcardsView(topicID: FrenchLessonPlan.staticTopics[0].id)
    }
}
