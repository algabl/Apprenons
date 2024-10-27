//
//  FlashcardsView.swift
//  Apprenons
//
//  Created by Alexander Black on 10/17/24.
//

import SwiftUI




struct FlashcardsView: View {

    
    let topicID: Int
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
    private struct Constants {
        static var cornerRadius: CGFloat = 10
        static let aspectRatio: CGFloat = 5 / 3
    }
    
    let flashcardID: UUID
    var topicID: Int
    @EnvironmentObject var viewModel: ApprenonsViewModel
    
    var flashcard: Flashcard? {
        viewModel.flashcard(withID: flashcardID, in: topicID)
    }
    
    @State private var isFlipped = false
    
    var isFaceUp: Bool {
        flashcard?.isFaceUp ?? true
    }

    var body: some View {
        ZStack {
            Group {
                if let flashcard {
                    ZStack {
                        CardFace(text: flashcard.front)
                            .opacity(isFlipped ? 0 : 1)
                        CardFace(text: flashcard.back)
                            .opacity(isFlipped ? 1 : 0)
                            .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                    }
                    .rotation3DEffect(
                        .degrees(isFlipped ? 180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                }
           
            }
            .aspectRatio(Constants.aspectRatio, contentMode: .fit)
           
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                isFlipped.toggle()
                viewModel.flip(flashcardID, in: topicID)
            }
        }
        .navigationTitle("Flashcards")
        .navigationBarTitleDisplayMode(.inline)
        .foregroundStyle(.blue)
     
    }
}

struct CardFace: View {
    let text: String
    
    var body: some View {
        ZStack {
          RoundedRectangle(cornerRadius: 10)
              .fill(.white)
          RoundedRectangle(cornerRadius: 10)
              .stroke()
          Text(text)
              .font(.largeTitle)
        }
    }
}

#Preview {
    NavigationStack {
        FlashcardsView(topicID: FrenchLessonPlan.staticTopics[0].id)
    }
}
